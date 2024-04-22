[#ftl/]
<div class="grid">
<table width="100%" class="grid-table">
  <thead class="grid-head">
    <tr>
      <th width="5%">课程</th>
      <th width="12%">代码</th>
      <th width="35%">名称</th>
      <th>要求学分</th>
      <th>完成学分</th>
      <th>成绩</th>
      <th>完成否</th>
      <th width="20%">备注</th>
    </tr>
  </thead>
  [@groupsData auditPlanResult.topGroupResults?sort_by('indexno'),1/]
</table>
</div>
<br><br>
[#macro groupsData courseGroups,lastNum]
  [#list courseGroups as group]
    <tr class="darkColumn" style="font-weight: bold">
      <td colspan="3" style="padding-left: 5px;text-align: left;">
        [#list 1..lastNum as d][/#list]${sg.next(lastNum?int)}&nbsp;${(group.name)?if_exists}
        [#if group.parent?? && !group.passed]
        <span style="color:#f1948a;font-weight: normal;">
        [#assign displayed=false/]
        [#if group.owedCredits>0](缺${group.owedCredits}分)[#assign displayed=true/][/#if]
        [#if group.neededGroups>0](要求${group.subCount}组 缺${group.neededGroups}组)[#assign displayed=true/][/#if]
        [#if !displayed]必修课未完成[/#if]
        </span>
        [/#if]
      </td>
      <td align="center">${(group.requiredCredits)?default('')}</td>
      <td align="center">${(group.passedCredits)?default('')} [#if ((group.convertedCredits)>0)](转换${(group.convertedCredits)}学分)[/#if]</td>
      <td></td>
      <td align="center">
        [#if group.passed]<span [#if group.parent??]style="font-weight: normal;"[/#if]>是</span>[#elseif !group.parent??]
          <span style="color:red;">缺${group.owedCredits}分</span>
        [/#if]
      </td>
      <td align="center">&nbsp;</td>
    </tr>
     [#list group.courseResults?sort_by(["course","code"]) as courseResult]
     [#local coursePassed=courseResult.passed/]
     <tr>
         <td align="center">${courseResult_index+1}</td>
         <td width="10%" style="padding-left: 5px;text-align: left;">${(courseResult.course.code)?default('')}</td>
         <td style="padding-left: 5px;text-align: left;">${(courseResult.course.name)?default('')}</td>
         <td align="center">${(courseResult.course.getCredits(std.level))?default('')}</td>
         <td align="center">[#if coursePassed]${(courseResult.course.getCredits(std.level))?default('')}[#else]0[/#if]</td>
         <td align="center">${courseResult.scores!}</td>
         <td align="center">
           [#if courseResult.scores!='--' && !courseResult.passed]${courseResult.passed?string("是","<font color='red'>否</font>")}[/#if]</td>
         <td align="center"><div title="${courseResult.remark?if_exists}">${courseResult.remark?if_exists}</div></td>
     </tr>
     [/#list]
      [#if (group.children?size!=0)]
      ${sg.reset((lastNum+1)?int)}
      [@groupsData group.children?sort_by('indexno'),lastNum+1/]
    [/#if]
  [/#list]
[/#macro]
