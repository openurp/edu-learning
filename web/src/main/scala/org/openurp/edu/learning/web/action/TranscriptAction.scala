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

import com.google.gson.Gson
import org.beangle.commons.collection.Collections
import org.beangle.commons.lang.Strings
import org.beangle.ems.app.Ems
import org.beangle.web.action.view.View
import org.openurp.base.std.model.{Graduate, Student}
import org.openurp.code.edu.model.{CourseTakeType, GradeType}
import org.openurp.edu.grade.config.TranscriptTemplate
import org.openurp.edu.grade.service.TranscriptTemplateService
import org.openurp.edu.grade.service.impl.SpringTranscriptDataProviderRegistry
import org.openurp.starter.web.support.StudentSupport


class TranscriptAction extends StudentSupport {
  var transcriptTemplateService: TranscriptTemplateService = _

  var dataProviderRegistry: SpringTranscriptDataProviderRegistry = _

  protected override def projectIndex(me: Student): View = {
    val students = List(me)
    var template: TranscriptTemplate = null
    val templateName = get("template").orNull
    if (null != templateName) {
      template = transcriptTemplateService.getTemplate(me.project, templateName)
    }
    var options: collection.Map[String, String] = Collections.newMap[String, String]
    if (null != template) {
      val joptions = new Gson().fromJson(template.options, classOf[java.util.Map[String, String]])
      import scala.jdk.javaapi.CollectionConverters.asScala
      if (null != joptions) options = asScala(joptions)
    }
    for (provider <- dataProviderRegistry.getProviders(options.getOrElse("providers", ""))) {
      put(provider.dataName, provider.getDatas(students, options))
    }
    put("school", me.project.school)
    put("students", students)
    val stdGraduates = entityDao.findBy(classOf[Graduate], "std", students)
    put("GraduateMap", stdGraduates.map(x => (x.std.id.toString, x)).toMap)
    put("GA", entityDao.get(classOf[GradeType], GradeType.EndGa))
    put("MAKEUP_GA", entityDao.get(classOf[GradeType], GradeType.MakeupGa))
    put("RESTUDY", CourseTakeType.Repeat)
    put("static_base", Ems.static)
    put("hasSignature", true)
    if (null != template) {
      var templatePath: String = template.template
      if (templatePath.startsWith("freemarker:")) templatePath = templatePath.substring("freemarker:".length)
      put("templatePath", templatePath)
    }
    forward()
  }
}
