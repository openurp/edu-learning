[#ftl]
[#assign maxTerm = plan.terms/]
[#include "planFunctions.ftl" /]
[#-- 计划课程的一格一格的学分信息 --]
[#macro simplePlanCourseCreditInfo planCourse]
    <td class="credit_hour">
        [#if planCourse.terms?exists]${planCourse.terms}[/#if]
    </td>
[/#macro]
[#-- 课程组的一格一格的学分信息 --]
[#macro simpleCourseGroupCreditInfo courseGroup]
    <td class="credit_hour">&nbsp;</td>
[/#macro]
<div class="container-fluid" style="width:95%">
  <table id="planInfoTable${plan.id}" name="planInfoTable${plan.id}" class="planTable"  style="font-size:12px;vnd.ms-excel.numberformat:@" width="100%">
      [#assign maxTerm=plan.terms/]
      [#assign courseTypeWidth=5*maxFenleiSpan/]
      [#if courseTypeWidth>15][#assign courseTypeWidth=15/][/#if]
      <thead>
          <tr align="center">
              <td colspan="${maxFenleiSpan}" width="${courseTypeWidth}%">分类</td>
              <td width="10%">课程代码</td>
              <td>课程名称</td>
              <td width="5%">学分</td>
              <td width="5%">学时</td>
              <td width="10%">开课学期</td>
              <td width="10%">备注</td>
          </tr>
          <tr>
          [#assign total_term_credit={} /]
      </thead>
      <tbody>
      [#list plan.topGroups! as courseGroup]
          [@drawGroup courseGroup simplePlanCourseCreditInfo simpleCourseGroupCreditInfo/]
      [/#list]
          [#-- 绘制总计 --]
          <tr>
              <td class="summary" colspan="${maxFenleiSpan + mustSpan}">全程总计</td>
              <td class="credit_hour summary">${plan.credits!(0)}</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
          </tr>
          [#if plan.program.remark??]
          <tr>
              <td align="center" colspan="${maxFenleiSpan + 1}">备注</td>
              <td colspan="5">&nbsp;${(plan.program.remark?html)!}</td>
          </tr>
          [/#if]
      </tbody>
  </table>
</div>
<script>
[@mergeCourseTypeCell plan teachPlanLevels 2/]
</script>
