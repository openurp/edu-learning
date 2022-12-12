[#ftl/]
[@b.head/]
<div class="container-fluid">
  [@b.toolbar title="计划完成情况"]
    bar.addPrint();
  [/@]
  [#assign std=student/]
  [#if planAuditResult??]
  <table align="center" class="infoTable">
   <tr>
    <td class="title" width="18%">学号:</td>
    <td class="content" width="18%">${std.code}</td>
    <td class="title" width="18%">姓名:</td>
    <td class="content" width="18%">${std.name}</td>
    <td class="title" width="18%">年级:</td>
    <td class="content" width="18%">${std.state.grade!}</td>
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
    <td class="title">GPA:</td>
    <td class="content">${(planAuditResult.gpa)?default("0")}</td>
   </tr>
   <tr>
    <td class="title">更新时间:</td>
    <td class="content">${(planAuditResult.updatedAt?string('yyyy-MM-dd HH:mm:ss'))!}
    <td class="title">备注:</td>
    <td class="content" colspan="3">
      ${(planAuditResult.remark?html)!} [#if !(planAuditResult.id?exists)]<font color="red">该完成情况，不作为最终审核结果</font>[/#if]
    </td>
   </tr>
  </table>
  [#include "resultTable.ftl" /]
  [#else]
    尚无您的计划完成情况。
  [/#if]
</div>
[@b.foot/]
