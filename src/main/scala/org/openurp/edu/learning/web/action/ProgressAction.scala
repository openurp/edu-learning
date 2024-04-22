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

import org.beangle.commons.lang.time.Weeks
import org.beangle.commons.text.seq.SeqNumStyle.{ARABIC, HANZI}
import org.beangle.commons.text.seq.{MultiLevelSeqGenerator, SeqNumStyle, SeqPattern}
import org.beangle.data.dao.OqlBuilder
import org.beangle.ems.app.web.WebBusinessLogger
import org.beangle.web.action.view.View
import org.openurp.base.std.model.Student
import org.openurp.edu.grade.model.AuditPlanResult
import org.openurp.starter.web.support.StudentSupport
import org.openurp.std.graduation.model.{GraduateResult, PlanResultCheck}

import java.time.{Instant, LocalDate}

class ProgressAction extends StudentSupport {
  var businessLogger: WebBusinessLogger = _

  protected override def projectIndex(std: Student): View = {
    val query = OqlBuilder.from(classOf[AuditPlanResult], "r")
    query.where("r.std = :std", std)
    val result = entityDao.search(query).headOption
    put("auditPlanResult", result)

    val sg = new MultiLevelSeqGenerator
    // 'A2','A3','B1','B2','B3','C1','C2','C3','D1','D2','D3','F'
    sg.add(new SeqPattern(HANZI, "{1}"))
    sg.add(new SeqPattern(HANZI, "({2})"))
    sg.add(new SeqPattern(ARABIC, "{3}"))
    sg.add(new SeqPattern(ARABIC, "{3}.{4}"))
    sg.add(new SeqPattern(ARABIC, "{3}.{4}.{5}"))
    sg.add(new SeqPattern(ARABIC, "{3}.{4}.{5}.{6}"))
    sg.add(new SeqPattern(ARABIC, "{3}.{4}.{5}.{6}.{7}"))
    sg.add(new SeqPattern(ARABIC, "{3}.{4}.{5}.{6}.{7}.{8}"))
    sg.add(new SeqPattern(ARABIC, "{3}.{4}.{5}.{6}.{7}.{8}.{9}"))
    put("sg", sg)
    put("student", std)

    val graduateResults = entityDao.findBy(classOf[GraduateResult], "std", std)
    val gr = graduateResults.sortBy(_.batch.graduateOn).reverse.headOption
    gr foreach { r =>
      if (r.batch.enableProgressConfirm) {
        put("planResultCheck", entityDao.findBy(classOf[PlanResultCheck], "std", std).headOption)
        put("graduateOn", r.batch.graduateOn)
        put("enableConfirm", Math.abs(Weeks.between(r.batch.graduateOn, LocalDate.now)) < 52)
      }
    }
    forward()
  }

  def confirm(): View = {
    val std = getStudent
    val query = OqlBuilder.from(classOf[AuditPlanResult], "r")
    query.where("r.std = :std", std)
    val result = entityDao.search(query).headOption
    result match
      case None => redirect("index", "没有找到你的审核结果，无法确认！")
      case Some(r) =>
        val c = entityDao.findBy(classOf[PlanResultCheck], "std", std).headOption.getOrElse(new PlanResultCheck(std))
        val gs = r.groupResults.sortBy(_.indexno)
        val owed =
          c.contents = gs.map(x => s"${x.indexno} ${x.name} 要求${x.requiredCredits} 完成${x.passedCredits} ${if x.owedCredits > 0 then s"缺${x.owedCredits}学分" else ""}").mkString("\n")
        c.requiredCredits = r.requiredCredits
        c.passedCredits = r.passedCredits
        c.owedCredits = r.owedCredits
        c.owedCredits2 = r.owedCredits2
        c.owedCredits3 = r.owedCredits3
        c.updatedAt = Instant.now
        entityDao.saveOrUpdate(c)
        val msg = s"确认了计划完成情况 要求${r.requiredCredits} 完成${r.passedCredits} ${if r.owedCredits > 0 then s"缺${r.owedCredits}学分"}"
        businessLogger.info(msg, r.id, Map.empty)
        redirect("index", "确认完毕")
  }
}
