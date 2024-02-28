[#ftl/]
[@b.head/]
[#include "../project.ftl" /]
<link id="jquery_theme_link" rel="stylesheet" href="${b.base}/static/css/mobile.css?rn=5" type="text/css"/>
<div class="container-fluid pc_content">
  [@b.toolbar title="计划完成情况"]
    bar.addPrint();
  [/@]
  [#assign std=student/]
  [#if planAuditResult??]
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
    <td class="content">${planAuditResult.auditStat.requiredCredits}&nbsp;/&nbsp;${planAuditResult.auditStat.passedCredits}</td>
    <td class="title">更新时间:</td>
    <td class="content">${(planAuditResult.updatedAt?string('yyyy-MM-dd HH:mm:ss'))!}
   </tr>
  </table>
  [#include "resultTable.ftl" /]
  [#else]
    尚无您的计划完成情况。
  [/#if]
</div>
[#include "mobileIndex.ftl"/]
[@b.foot/]
