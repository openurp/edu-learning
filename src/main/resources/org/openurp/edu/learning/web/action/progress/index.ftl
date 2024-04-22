[#ftl/]
[@b.head/]
[#include "../project.ftl" /]
<div class="container">
  [@b.toolbar title="计划完成情况"]
    bar.addPrint();
  [/@]
  [#if enableConfirm!false]
    [#include "confirm.ftl" /]
  [/#if]

  [#assign std=student/]
  [#if auditPlanResult??]
  <table align="center" class="infoTable">
   <tr>
    <td class="title" width="15%">学号:</td>
    <td class="content" width="20%">${std.code}</td>
    <td class="title" width="15%">姓名:</td>
    <td class="content" width="20%">${std.name}</td>
    <td class="title" width="10%">年级:</td>
    <td class="content" width="20%">${std.state.grade!}</td>
   </tr>
   <tr>
    <td class="title">培养层次:</td>
    <td class="content">${std.level.name}</td>
    <td class="title">学生类别:</td>
    <td class="content">${std.stdType.name}</td>
    <td class="title">院系:</td>
    <td class="content">${std.state.department.name}</td>
   </tr>
   <tr>
    <td class="title">专业/方向:</td>
    <td class="content">${std.state.major.name}&nbsp;${(std.state.direction.name)!}</td>
    <td class="title">要求学分/实修学分:</td>
    <td class="content">${auditPlanResult.requiredCredits}&nbsp;/&nbsp;${auditPlanResult.passedCredits}</td>
    <td class="title">更新时间:</td>
    <td class="content">${(auditPlanResult.updatedAt?string('yyyy-MM-dd HH:mm:ss'))!}
   </tr>
  </table>
  [#include "resultTable.ftl" /]
  [#else]
    尚无您的计划完成情况。
  [/#if]
</div>
[@b.foot/]
