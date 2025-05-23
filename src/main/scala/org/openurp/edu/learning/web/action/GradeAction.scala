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

import org.beangle.commons.bean.orderings.PropertyOrdering
import org.beangle.commons.collection.Collections
import org.beangle.webmvc.view.View
import org.openurp.base.model.{Project, Semester}
import org.openurp.base.std.model.Student
import org.openurp.code.edu.model.GradeType
import org.openurp.edu.grade.domain.CourseGradeProvider
import org.openurp.edu.grade.model.{CourseGrade, StdGpa}
import org.openurp.starter.web.support.StudentSupport

import scala.collection.mutable

class GradeAction extends StudentSupport {

  var courseGradeProvider: CourseGradeProvider = null

  protected override def projectIndex(std: Student): View = {
    val grades = courseGradeProvider.getPublished(std)
    put("stdGpa", entityDao.findBy(classOf[StdGpa], "std", std).headOption)
    val gradeTypes = codeService.get(classOf[GradeType], GradeType.Usual, GradeType.Middle, GradeType.End, GradeType.Makeup, GradeType.Delay, GradeType.EndGa)
    val publishedGradeTypes = Collections.newSet[GradeType]
    val semesterGrades = Collections.newMap[Semester, mutable.Buffer[CourseGrade]]
    for (cg <- grades) {
      for (gt <- gradeTypes) {
        cg.getGrade(gt) foreach { g =>
          if null != g && g.published then publishedGradeTypes.add(gt)
        }
      }
      val sgs = semesterGrades.getOrElseUpdate(cg.semester, Collections.newBuffer[CourseGrade])
      sgs.addOne(cg)
    }

    given project: Project = std.project

    put("style", getConfig("edu.grade.std_page_style", "normal"))
    put("semesterGrades", semesterGrades)
    put("grades", grades.sorted(PropertyOrdering.by("semester.code desc,course.code")))
    put("gradeTypes", publishedGradeTypes)
    put("std", std)
    forward()
  }

}
