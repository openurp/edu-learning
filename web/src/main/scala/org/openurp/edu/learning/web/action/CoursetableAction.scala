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

import org.beangle.commons.bean.Properties
import org.beangle.commons.collection.Order
import org.beangle.commons.lang.time.{WeekDay, WeekTime}
import org.beangle.commons.lang.{Numbers, Strings}
import org.beangle.data.dao.{EntityDao, OqlBuilder}
import org.beangle.data.model.Entity
import org.beangle.ems.app.Ems
import org.beangle.web.action.context.Params
import org.beangle.web.action.view.View
import org.beangle.webmvc.support.helper.PopulateHelper
import org.openurp.base.edu.model.*
import org.openurp.base.edu.service.TimeSettingService
import org.openurp.base.model.Semester
import org.openurp.base.service.{ProjectPropertyService, SemesterService}
import org.openurp.base.std.model.{Squad, Student}
import org.openurp.edu.Features
import org.openurp.edu.clazz.config.ScheduleSetting
import org.openurp.edu.clazz.domain.{ClazzProvider, WeekTimeBuilder}
import org.openurp.edu.clazz.model.CourseTaker
import org.openurp.edu.learning.web.helper.CourseTableSetting
import org.openurp.edu.schedule.service.CourseTable
import org.openurp.starter.web.support.StudentSupport

import java.time.LocalDate
import scala.collection.mutable

class CoursetableAction extends StudentSupport {

  var clazzProvider: ClazzProvider = _

  var timeSettingService: TimeSettingService = _

  protected override def projectIndex(std: Student): View = {
    val semester = getSemester()
    val timeSetting = timeSettingService.get(std.project, semester, Some(std.state.get.campus))
    put("semester", semester)
    val weekIndex = get("weekIndex", "*")
    val setting = new CourseTableSetting(semester, get("setting.category", "std"))
    val ssQuery = OqlBuilder.from(classOf[ScheduleSetting], "ss")
    ssQuery.where("ss.project=:project and ss.semester=:semester", std.project, semester)
    val ss = entityDao.search(ssQuery).headOption.getOrElse(new ScheduleSetting)
    setting.weektimes = WeekTimeBuilder.build(semester, weekIndex)
    put("weekIndex", weekIndex)
    val resource = setting.category match {
      case "std" => std
      case "squad" => std.state.get.squad.get
    }
    val courseTable = buildCourseTable(resource, setting, timeSetting, ss)
    put("table", courseTable)
    put("setting", setting)
    put("student",std)
    put("ems", Ems)
    forward()
  }

  private def buildCourseTable(resource: Object, setting: CourseTableSetting, ts: TimeSetting, ss: ScheduleSetting) = {
    val table = new CourseTable(setting.semester, resource, setting.category)
    table.timeSetting = ts
    val clazzes = resource match {
      case std: Student =>
        val takers = clazzProvider.getClazzes(setting.semester, std)
        val takerMap = takers.map(x => (x.clazz, x)).toMap
        put("takerMap", takerMap)
        takers.map(_.clazz)
      case squad: Squad => clazzProvider.getClazzes(setting.semester, squad)
    }
    if ss.timePublished then table.setClazzes(clazzes, setting.weektimes)
    else table.setClazzes(clazzes)
    table.placePublished = ss.placePublished
    table.timePublished = ss.timePublished
    table
  }

}
