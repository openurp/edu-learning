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
        <thead>
            <tr align="center">
                <td rowspan="2" colspan="${maxFenleiSpan}" width="10%">分类</td>
                <td rowspan="2" width="9%">课程代码</td>
                <td rowspan="2" width="26%">课程名称</td>
                <td rowspan="2" width="5%">学分</td>
                <td colspan="${maxTerm}" width="25%">按学期学分分配</td>
                <td rowspan="2" width="15%">开课院系</td>
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
            [@drawGroup courseGroup planCourseCreditInfo courseGroupCreditInfo/]
          [/#if]
        [/#list]
            [#-- 绘制总计 --]
            <tr>
                <td class="summary" colspan="${maxFenleiSpan + mustSpan}">全程总计</td>
                <td class="credit_hour summary">${plan.credits!(0)}</td>
            [#list plan.startTerm..plan.endTerm as i]
                <td class="credit_hour">${total_term_credit[i?string]}</td>
            [/#list]
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td align="center" colspan="${maxFenleiSpan + 1}">备注</td>
                <td colspan="${5 + maxTerm}">&nbsp;${(plan.program.remark?html)!}</td>
            </tr>
        </tbody>
    </table>
</div>
<script>
[@mergeCourseTypeCell plan teachPlanLevels 2/]
</script>
