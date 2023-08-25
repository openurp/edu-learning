[#ftl]
[#assign maxTerm = plan.terms/]
[#assign terms = Parameters['terms']?default("")]
[#include "planFunctions.ftl" /]
[#--
课程组的最深层次：${teachPlanLevels}
叶子最深处于第几层：${teachPlanLeafLevels}
--]
<div class="container-fluid" style="width:95%">
    <table id="planInfoTable${plan.id}" name="planInfoTable${plan.id}" class="planTable"  style="font-size:12px;vnd.ms-excel.numberformat:@" width="100%">
        [#assign maxTerm=plan.terms /]
        [#assign courseTypeWidth=5*maxFenleiSpan/]
        [#if courseTypeWidth>15][#assign courseTypeWidth=15/][/#if]
        <thead>
            <tr align="center">
                <td rowspan="2" colspan="${maxFenleiSpan}" width="${courseTypeWidth}%">分类</td>
                <td rowspan="2" width="10%">课程代码</td>
                <td rowspan="2">课程名称</td>
                <td rowspan="2" width="5%">学分</td>
                <td rowspan="2" width="5%">学时</td>
                <td colspan="${maxTerm}" width="${maxTerm*3.5}%">各学期学分分布</td>
                <td rowspan="2" width="10%">备注</td>
            </tr>
            <tr>
            [#assign total_term_credit={} /]
            [#list plan.startTerm..plan.endTerm as i ]
                [#assign total_term_credit=total_term_credit + {i:0} /]
                <td width="[#if maxTerm?exists&&maxTerm!=0]${25/maxTerm}[#else]2[/#if]%" style="text-align: center;">${i}</td>
            [/#list]
            </tr>
        </thead>
        <tbody>
        [#list plan.groups?sort_by("indexno") as courseGroup]
          [#if !courseGroup.parent??]
            [@drawGroup courseGroup planCourseCreditInfo courseGroupEmptyInfo/]
          [/#if]
        [/#list]
            <tr>
                <td class="summary" colspan="${maxFenleiSpan + mustSpan}">全程总计</td>
                <td class="credit_hour summary">${plan.credits!(0)}</td>
                <td class="credit_hour summary">&nbsp;[#--学时--]</td>
            [#list plan.startTerm..plan.endTerm as i]
                <td class="credit_hour">${total_term_credit[i?string]}</td>
            [/#list]
                <td>&nbsp;</td>
            </tr>
            [#if plan.program.remark??]
            <tr>
                <td align="center" colspan="${maxFenleiSpan}">备注</td>
                [#-- 5= 代码+名称+学时+学分+备注--]
                  [#assign remark = plan.program.remark?replace("\r","")/]
                <td style="padding-left: 10px;line-height: 1.5rem;" colspan="${5 + (plan.endTerm - plan.startTerm + 1)}">${remark?replace('\n','<br>')}</td>
            </tr>
            [/#if]
        </tbody>
    </table>
    <br><br>
</div>
<script>
[@mergeCourseTypeCell plan teachPlanLevels 2/]
</script>
