<table width="100%" class="infoTable">
  <tr>
   <td class="title">学号</td><td>${((std.code)?default(""))?trim}</td>
   <td class="title">姓名</td><td>${std.name}</td>
   <td class="title">性别</td><td>${((std.person.gender.name)?default(""))?trim}</td>
   <td class="title">学习形式</td><td>${std.studyType.name}</td>
   <td class="title">培养类型</td><td>${std.eduType.name}</td>
   <td class="title">培养层次</td><td>${std.level.name}</td>
  </tr>
  <tr>
    <td class="title">年级</td><td>${std.state.grade.name}</td>
    <td class="title">院系</td><td>${std.state.department.name}</td>
    <td class="title">专业、方向</td><td colspan="2">${(std.state.major.name)?default("")} ${(std.state.direction.name)!}</td>
    <td class="title">班级</td><td colspan="2">${(std.state.squad.name)!}</td>
  [#if std.tutor??]
    <td class="title">导师</td><td>${(std.tutor.name)!}</td>
  [#else]
    <td class="title">辅导员</td><td>${(std.state.squad.mentor.name)!}</td>
  [/#if]
  </tr>
</table>
