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

import org.beangle.commons.codec.digest.Digests
import org.beangle.data.dao.{EntityDao, OqlBuilder}
import org.beangle.ems.app.{Ems, EmsApp}
import org.beangle.security.Securities
import org.beangle.webmvc.support.ActionSupport
import org.beangle.webmvc.view.{Status, View}
import org.openurp.base.std.model.Student
import org.openurp.edu.clazz.config.ScheduleSetting
import org.openurp.edu.clazz.domain.ClazzProvider
import org.openurp.edu.clazz.model.*
import org.openurp.edu.course.model.ClazzPlan

/** 学生查看单个教学任务
 * 包括课程安排详情、考试详情、通知、课程资料界面
 */
class ClazzAction extends ActionSupport {
  var entityDao: EntityDao = _

  var clazzProvider: ClazzProvider = _

  def index(): View = {
    val taker = getTake()
    val project = taker.clazz.project
    val semester = taker.clazz.semester

    val query = OqlBuilder.from(classOf[ScheduleSetting], "setting")
    query.where("setting.project =:project", project)
    query.where("setting.semester =:semester", semester)
    query.cacheable()
    val setting = entityDao.search(query).headOption.getOrElse(new ScheduleSetting)
    put("setting", setting)
    put("clazz", taker.clazz)
    val avatarUrls = taker.clazz.teachers.map(x => (x.id, Ems.api + "/platform/user/avatars/" + Digests.md5Hex(x.code) + ".jpg")).toMap
    put("avatarUrls", avatarUrls)
    put("clazzes", clazzProvider.getClazzes(semester, taker.std).map(_.clazz))
    forward()
  }

  private def getTake(): CourseTaker = {
    val query = OqlBuilder.from(classOf[CourseTaker], "ct")
    query.where("ct.clazz.id=:clazzId", getLong("clazz.id").getOrElse(0))
    query.where("ct.std.code=:code", Securities.user)
    entityDao.search(query).head
  }

  def materials(): View = {
    val clazzId = getLong("clazz.id").getOrElse(0L)
    val query = OqlBuilder.from(classOf[ClazzDoc], "doc")
    query.where("doc.clazz.id=:clazzId", clazzId)
    put("materials", entityDao.search(query))
    forward()
  }

  def bulletin(): View = {
    val clazzId = getLong("clazz.id").getOrElse(0L)
    val query = OqlBuilder.from(classOf[ClazzBulletin], "bulletin")
    query.where("bulletin.clazz.id=:clazzId", clazzId)
    put("bulletin", entityDao.search(query).headOption)
    forward()
  }

  def teachingPlan(): View = {
    val clazzId = getLong("clazz.id").getOrElse(0L)
    val query = OqlBuilder.from(classOf[ClazzPlan], "plan")
    query.where("plan.clazz.id=:clazzId", clazzId)
    put("plan", entityDao.search(query).headOption)
    forward()
  }
  /**
   * 下载公告附件或者课程资料
   *
   * @return
   */
  def download(): View = {
    val noticeFileId = getLong("noticeFile.id").getOrElse(0L)
    val materialId = getLong("material.id").getOrElse(0L)
    val bulletinId = getLong("bulletin.id").getOrElse(0L)
    if (noticeFileId > 0) {
      val noticeFile = entityDao.get(classOf[ClazzNoticeFile], noticeFileId)
      val path = EmsApp.getBlobRepository(true).url(noticeFile.filePath)
      redirect(to(path.get.toString), "x")
    } else if (materialId > 0) {
      val material = entityDao.get(classOf[ClazzDoc], materialId)
      material.filePath match {
        case None => Status.NotFound
        case Some(p) =>
          val path = EmsApp.getBlobRepository(true).url(p)
          redirect(to(path.get.toString), "x")
      }
    } else {
      val bulletin = entityDao.get(classOf[ClazzBulletin], bulletinId)
      bulletin.contactQrcodePath match {
        case None => Status.NotFound
        case Some(p) =>
          val path = EmsApp.getBlobRepository(true).url(p)
          redirect(to(path.get.toString), "x")
      }
    }
  }

  def notices(): View = {
    val clazzId = getLong("clazz.id").getOrElse(0L)
    val query = OqlBuilder.from(classOf[ClazzNotice], "notice")
    query.where("notice.clazz.id=:clazzId", clazzId)
    put("notices", entityDao.search(query))
    forward()
  }

}
