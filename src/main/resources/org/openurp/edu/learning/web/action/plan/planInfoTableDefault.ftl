[#ftl]
[#assign maxTerm = plan.terms/]
[#assign terms = Parameters['terms']?default("")]
[#include "planFunctions.ftl" /]

<div class="container-fluid" style="width:95%">
    <table id="planInfoTable${plan.id}" name="planInfoTable${plan.id}" class="grid-table planTable"  style="font-size:12px;vnd.ms-excel.numberformat:@" width="100%">
        [#assign maxTerm=plan.terms /]
        [#assign courseTypeWidth=5*maxFenleiSpan/]
        [#if courseTypeWidth>15][#assign courseTypeWidth=15/][/#if]
        <thead class="grid-head">
            <tr align="center">
                <th rowspan="2" colspan="${maxFenleiSpan}" width="${courseTypeWidth}%">分类</th>
                <th rowspan="2" width="10%">课程代码</th>
                <th rowspan="2">课程名称</th>
                <th rowspan="2" width="5%">学分</th>
                [#if displayCreditHour]<th rowspan="2" width="5%">学时</th>[/#if]
                <th colspan="${maxTerm}" width="${maxTerm*3.5}%">各学期学分分布</th>
                <th rowspan="2" width="10%">备注</th>
            </tr>
            <tr>
            [#assign total_term_credit={} /]
            [#list plan.program.startTerm..plan.program.endTerm as i ]
                [#assign total_term_credit=total_term_credit + {i:0} /]
                <th width="[#if maxTerm?exists&&maxTerm!=0]${25/maxTerm}[#else]2[/#if]%" style="text-align: center;">${i}</th>
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
                [#if displayCreditHour]<td class="credit_hour summary">&nbsp;</td>[/#if]
            [#list plan.program.startTerm..plan.program.endTerm as i]
                <td class="credit_hour">&nbsp;</td>
            [/#list]
                <td>&nbsp;</td>
            </tr>
            [#if plan.program.remark??]
            <tr>
                <td align="center" colspan="${maxFenleiSpan}">备注</td>
                [#-- 5= 代码+名称+学时+学分+备注--]
                [#assign remarkSpan = 3 + 1 +maxTerm/]
                [#if displayCreditHour][#assign remarkSpan =1+remarkSpan/][/#if]
                  [#assign remark = plan.program.remark?replace("\r","")/]
                <td class="remark" style="padding-left: 10px;line-height: 1.5rem;" colspan="${remarkSpan}">${remark?replace('\n','<br>')}</td>
            </tr>
            [/#if]
        </tbody>
    </table>
    <br><br>
</div>
<script>
[@mergeCourseTypeCell plan teachPlanLevels 2/]
</script>
