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

import org.beangle.data.dao.{EntityDao, OqlBuilder}
import org.beangle.ems.app.EmsApp
import org.beangle.web.action.annotation.{mapping, param}
import org.beangle.web.action.support.ActionSupport
import org.beangle.web.action.view.{Status, View}
import org.openurp.base.service.SemesterService
import org.openurp.base.std.model.Student
import org.openurp.edu.clazz.domain.ClazzProvider
import org.openurp.edu.clazz.model.{Clazz, ClazzNotice, ClazzNoticeFile}
import org.openurp.starter.web.support.StudentSupport

class NoticeAction extends StudentSupport {

  var clazzProvider: ClazzProvider = _

  protected override def projectIndex(std: Student): View = {
    val semester = getSemester
    val clazzes = clazzProvider.getClazzes(semester, std).map(_.clazz)
    val notices = getQueryBuilder(clazzes)
    put("notices", notices)
    forward()
  }

  private def getQueryBuilder(clazzes: collection.Seq[Clazz]): Seq[ClazzNotice] = {
    val query = OqlBuilder.from(classOf[ClazzNotice], "cn")
    query.where("cn.clazz in(:clazzes)", clazzes)
    query.orderBy("cn.updatedAt desc")
    //query.limit(1, 10)
    entityDao.search(query)
  }

  @mapping("{id}")
  def info(@param("id") id: String): View = {
    put("notice", entityDao.get(classOf[ClazzNotice], id.toLong))
    forward()
  }

  /**
   * 下载公告附件或者课程资料
   *
   * @return
   */
  def download(): View = {
    getLong("noticeFile.id") match {
      case None => Status.NotFound
      case Some(id) =>
        val noticeFile = entityDao.get(classOf[ClazzNoticeFile], id)
        val path = EmsApp.getBlobRepository(true).url(noticeFile.filePath)
        redirect(to(path.get.toString), "x")
    }
  }
}
