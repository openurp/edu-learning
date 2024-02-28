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

import org.beangle.ems.app.Ems
import org.beangle.web.action.view.View
import org.openurp.base.std.model.Student
import org.openurp.starter.web.support.StudentSupport

/**
 * 选课
 */
class ChooseAction extends StudentSupport {

  protected override def projectIndex(student: Student): View = {
    redirect(to(Ems.webapp + "/edu/clazz/student/stdElectCourse.action"), "")
  }
}
