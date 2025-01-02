/*
 * Copyright (C) 2014, The OpenURP Software.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.openurp.edu.learning.web.action

import org.beangle.commons.collection.Collections
import org.beangle.data.dao.OqlBuilder
import org.beangle.ems.app.web.WebBusinessLogger
import org.beangle.security.Securities
import org.beangle.webmvc.context.Params
import org.beangle.webmvc.view.View
import org.beangle.webmvc.support.helper.PopulateHelper
import org.openurp.base.model.Project
import org.openurp.base.std.model.Student
import org.openurp.code.edu.model.{ExamDeferReason, ExamType}
import org.openurp.edu.clazz.domain.{ClazzProvider, ExamTakerProvider}
import org.openurp.edu.clazz.model.CourseTaker
import org.openurp.edu.exam.flow.ExamDeferApply
import org.openurp.edu.exam.model.{ExamNotice, ExamTaker}
import org.openurp.edu.service.Features
import org.openurp.starter.web.support.StudentSupport

import java.time.{Instant, LocalTime, ZoneId}

class ExamAction extends StudentSupport {

  var clazzProvider: ClazzProvider = _
  var businessLogger: WebBusinessLogger = _
  var examTakerProvider: ExamTakerProvider = _

  protected override def projectIndex(std: Student): View = {
    given project: Project = std.project

    val semester = getSemester
    val courseTakers = clazzProvider.getClazzes(semester, std)

    val finalTakers = Collections.newMap[CourseTaker, ExamTaker]
    val otherTakers = Collections.newMap[CourseTaker, ExamTaker]
    val examTakers = examTakerProvider.getStdTakers(semester, std).groupBy(_.clazz)
    if (courseTakers.nonEmpty) {
      courseTakers foreach { courseTaker =>
        examTakers.get(courseTaker.clazz).foreach { ets =>
          ets.find(et => et.examType.id == ExamType.Final) foreach { examTaker =>
            finalTakers.put(courseTaker, examTaker)
          }
          ets.find(et => et.examType.id != ExamType.Final) foreach { examTaker =>
            otherTakers.put(courseTaker, examTaker)
          }
        }
      }
    }
    put("semester", semester)
    put("courseTakers", courseTakers)
    put("finalTakers", finalTakers)
    put("otherTakers", otherTakers)
    put("showSeatNo", getConfig(Features.Exam.ShowStdSeatNo))
    //查找考试通知
    val noticeQuery = OqlBuilder.from(classOf[ExamNotice], "notice")
    noticeQuery.where("notice.project=:project", project)
    noticeQuery.where("notice.semester=:semester", semester)
    val notices = entityDao.search(noticeQuery)
    put("finalExamNotice", notices.find(_.examType.id == ExamType.Final))
    put("otherExamNotice", notices.find(_.examType.id != ExamType.Final))

    //查找考试申请
    val applies = entityDao.findBy(classOf[ExamDeferApply], "std" -> std, "clazz.semester" -> semester)
    val applyMap = applies.map { x => (x.clazz.id.toString + "_" + x.examType.id.toString, x) }.toMap
    put("applyMap", applyMap)
    put("DeferApplyEnabled", getConfig(Features.Exam.DeferApplyEnabled))
    forward()
  }

  def editApply(): View = {
    val examTaker = entityDao.get(classOf[ExamTaker], getLongId("examTaker"))
    put("examTaker", examTaker)

    given project: Project = examTaker.clazz.project

    put("reasons", getCodes(classOf[ExamDeferReason]))
    put("apply", getDeferApply(examTaker))
    forward()
  }

  def submitApply(): View = {
    val taker = entityDao.get(classOf[ExamTaker], getLongId("examTaker"))
    val apply = getDeferApply(taker)
    if (apply.examBeginAt.nonEmpty) {
      if (apply.examBeginAt.get.isBefore(Instant.now())) {
        return redirect("index", "已经开始的考试无法申请缓考")
      }
    }
    PopulateHelper.populate(apply, Params.sub("apply"))
    apply.status = "已提交"
    entityDao.saveOrUpdate(apply)
    val msg = s"提交了${taker.clazz.course.name}(${taker.clazz.crn})的${taker.examType.name}的缓考申请"
    businessLogger.info(msg, apply.id, Map.empty)
    redirect("index", "提交成功")
  }

  def cancelApply(): View = {
    val apply = entityDao.get(classOf[ExamDeferApply], getLongId("apply"))
    assert(apply.std.code == Securities.user, s"当前用户是${Securities.user},考试记录是${apply.std.code}")
    if (apply.persisted) {
      val msg = s"撤销了${apply.clazz.course.name}(${apply.clazz.crn})的${apply.examType.name}的缓考申请"
      businessLogger.info(msg, apply.id, Map.empty)
      entityDao.remove(apply)
    }
    redirect("index", "撤销成功")
  }

  def printApply(): View = {
    val std = getStudent
    val semester = getSemester
    val applies = entityDao.findBy(classOf[ExamDeferApply], "std" -> std, "clazz.semester" -> semester)
    val applyAt = applies.map(_.updatedAt).max
    put("mobile", applies.map(_.mobile.getOrElse("")).toSet.mkString(","))
    put("applyAt", applyAt)
    put("applies", applies)
    put("semester", semester)
    put("std", std)
    forward()
  }

  private def getDeferApply(examTaker: ExamTaker): ExamDeferApply = {
    val apply = entityDao.findBy(classOf[ExamDeferApply], "std" -> examTaker.std,
      "examType" -> examTaker.examType, "clazz" -> examTaker.clazz).headOption match {
      case None =>
        val apl = new ExamDeferApply
        apl.std = examTaker.std
        apl.examType = examTaker.examType
        apl.clazz = examTaker.clazz
        examTaker.activity foreach { a =>
          a.examOn foreach { examOn =>
            apl.examBeginAt = Some(examOn.atTime(LocalTime.of(a.beginAt.hour, a.beginAt.minute)).atZone(ZoneId.systemDefault()).toInstant)
          }
        }
        apl.updatedAt = Instant.now
        val user = getUser
        apl.mobile = user.mobile
        apl
      case Some(apply) => apply
    }
    assert(apply.std.code == Securities.user, s"当前用户是${Securities.user},考试记录是${apply.std.code}")
    apply
  }

}
