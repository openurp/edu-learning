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

import org.beangle.commons.cdi.BindModule
import org.openurp.edu.clazz.domain.DefaultClazzProvider

class DefaultModule extends BindModule {

  override def binding(): Unit = {
    bind(classOf[AlternativeAction])
    bind(classOf[ChooseAction])
    bind(classOf[ClazzAction])
    bind(classOf[CoursetableAction])
    bind(classOf[CourseTypeAction])
    bind(classOf[ExamAction])
    bind(classOf[GradeAction])
    bind(classOf[NoticeAction])
    bind(classOf[PlanAction])
    bind(classOf[ProgressAction])
    bind(classOf[TranscriptAction])
  }
}
