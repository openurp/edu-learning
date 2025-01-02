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
import org.beangle.commons.lang.Strings
import org.beangle.data.dao.OqlBuilder
import org.beangle.ems.app.web.WebBusinessLogger
import org.beangle.security.Securities
import org.beangle.webmvc.support.action.EntityAction
import org.beangle.webmvc.view.View
import org.openurp.base.edu.model.Course
import org.openurp.base.model.Project
import org.openurp.base.std.model.Student
import org.openurp.edu.grade.domain.CourseGradeProvider
import org.openurp.edu.program.domain.{AlternativeCourseProvider, CoursePlanProvider}
import org.openurp.edu.program.flow.CourseAlternativeApply
import org.openurp.edu.program.model.{SharePlan, StdAlternativeCourse}
import org.openurp.edu.service.Features
import org.openurp.starter.web.support.StudentSupport

import java.time.Instant
import scala.collection.mutable

class AlternativeAction extends StudentSupport, EntityAction[CourseAlternativeApply] {

  var coursePlanProvider: CoursePlanProvider = _

  var alternativeCourseProvider: AlternativeCourseProvider = _

  var courseGradeProvider: CourseGradeProvider = _

  var businessLogger: WebBusinessLogger = _

  protected override def projectIndex(std: Student): View = {
    val builder = OqlBuilder.from(classOf[CourseAlternativeApply], "apply")
      .where("apply.std=:std", std)
    put("applies", entityDao.search(builder))
    forward()
  }

  def applyForm(): View = {
    val std = getStudent

    given project: Project = std.project

    put("std", std)
    val pcourses = planCourses(std)

    val scores = gradeScores(std)
    val hasGrade = pcourses.filter(scores.contains)
    pcourses --= hasGrade
    put("planCourses", pcourses)
    put("gradeCourses", scores.keySet)
    put("scores", scores)
    put("multiple_enabled", getConfig(Features.Program.AlternativeApplyMultipleEnabled))
    forward()
  }

  private def planCourses(std: Student): collection.mutable.Buffer[Course] = {
    val courses = Collections.newSet[Course]
    coursePlanProvider.getCoursePlan(std) foreach { plan =>
      for (courseGroup <- plan.groups; planCourse <- courseGroup.planCourses) {
        courses.add(planCourse.course)
      }
    }
    val spQuery = OqlBuilder.from(classOf[SharePlan], "sp")
    spQuery.where("sp.project=:project", std.project)
    spQuery.where("sp.level=:level and sp.eduType =:eduType", std.level, std.eduType)
    spQuery.where(":grade between sp.fromGrade.code and sp.toGrade.code", std.state.get.grade.code)
    entityDao.search(spQuery) foreach { sp =>
      for (cg <- sp.groups; planCourse <- cg.planCourses) {
        courses.add(planCourse.course)
      }
    }
    courses.toBuffer.sortBy(_.name)
  }

  def gradeScores(std: Student): collection.Map[Course, String] = {
    val scores = Collections.newMap[Course, String]
    val grades = courseGradeProvider.getPublished(std)
    grades foreach { g =>
      if (g.passed) {
        scores.put(g.course, g.scoreText.getOrElse("--"))
      }
    }
    scores
  }

  def doApply(): View = {
    val apply = populateEntity(classOf[CourseAlternativeApply], "apply")
    apply.std = getStudent

    val project = getProject
    val originIdStr = get("originIds", "") // 原课程代码串
    val substituteIdStr = get("substituteIds", "") // 替换课程代码串
    fillCourse(project, apply.olds, originIdStr)
    fillCourse(project, apply.news, substituteIdStr)
    var stdCourseSubId: Long = 0
    if (apply.persisted) {
      stdCourseSubId = apply.id
    }
    if (apply.olds.isEmpty || apply.news.isEmpty) {
      redirect("index", "保存失败")
    } else {
      val builder = OqlBuilder.from(classOf[StdAlternativeCourse], "stdAlternativeCourse")
      builder.where("stdAlternativeCourse.std.id=:stdId", apply.std.id)
        .where("stdAlternativeCourse.std.project= :project", project)
      if (stdCourseSubId != 0) {
        builder.where("stdAlternativeCourse.id !=:stdCourseSubId", stdCourseSubId)
      }
      val stdAlternativeCourses = entityDao.search(builder)
      val duplicated = stdAlternativeCourses.exists { stdCourseSub =>
        stdCourseSub.olds == apply.olds && stdCourseSub.news == apply.news
      }
      if (duplicated) {
        return redirect("index", "该替代课程组合已存在!")
      }
      apply.updatedAt = Instant.now()
      if (isDoubleAlternativeCourse(apply)) {
        entityDao.saveOrUpdate(apply)
        redirect("index", "info.save.success")
      } else {
        redirect("index", "原课程与替代课程一样!")
      }
    }
  }

  private def fillCourse(project: Project, courses: mutable.Set[Course], courseCodeSeq: String): Unit = {
    val courseCodes = Strings.split(courseCodeSeq, ",")
    courses.clear()
    if (courseCodes != null) for (i <- courseCodes.indices) {
      val query = OqlBuilder.from(classOf[Course], "course").cacheable()
        .where("course.id = :id", courseCodes(i).toLong)
        .where("course.project = :project", project)
      courses ++= entityDao.search(query)
    }
  }

  /**
   * 由于前台不好判断原课程和替代
   * 课程是否一样所以放到后台判断
   *
   * @param apply 替代申请
   * @return true:原课程和替代课程不一样 false:原课程与替代课程一样
   */
  private def isDoubleAlternativeCourse(apply: CourseAlternativeApply): Boolean = {
    var bool = false
    val courseOrigins = apply.olds
    val courseSubstitutes = apply.news
    for (Origin <- courseOrigins) {
      if (!courseSubstitutes.contains(Origin)) bool = true
    }
    for (Substitute <- courseSubstitutes) {
      if (!courseOrigins.contains(Substitute)) bool = true
    }
    bool
  }

  def remove(): View = {
    val id = getLongId("apply")
    val apply = entityDao.get(classOf[CourseAlternativeApply], id)
    if (apply.approved.contains(true)) return redirect("index", "不能删除已经审核通过的申请")
    val me = Securities.user
    if (!(apply.std.code == me)) return redirect("index", "不能删除别人的申请")
    entityDao.remove(apply)
    redirect("index", "成功删除申请")
  }

}
