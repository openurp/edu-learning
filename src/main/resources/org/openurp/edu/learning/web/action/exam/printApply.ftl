[@b.head/]
[@b.toolbar title="缓考申请打印"]
  bar.addPrint();
  bar.addClose();
[/@]
  [#assign whitespace]&nbsp;&nbsp;&nbsp;&nbsp;[/#assign]
  <table width="100%" align="center" style="font-size:14px">
    <tr align="center">
      <td><h5>${semester.schoolYear}学年 [#if semester.name='1']第一学期[#elseif semester.name='2']第二学期<#else>${semester.name}[/#if] 缓考申请表</h5></td>
    </tr>
    <tr><td>&nbsp;</td></tr>
    <tr align="center">
     <td>姓名:${std.name}${whitespace}学号:${std.code}${whitespace}院系:${std.department.name}${whitespace}专业:${(std.major.name)!}</td>
    </tr>
    <tr  align="center">
      <td>申请日期:${applyAt?string("yyyy-MM-dd")}${whitespace}${whitespace}申请人签名:${whitespace}${whitespace}${whitespace}${whitespace}${whitespace}联系电话:${mobile!}</td>
    </tr>
  </table>
  <br>

  <table width="100%" align="center" class="grid-table">
    <thead class="grid-head">
     <tr>
     <th width="10%">课程序号</th>
     <th width="10%">课程代码</th>
     <th width="25%">考试日期</th>
     <th width="25%">课程名称</th>
     <th width="30%">缓考原因</th>
     </tr>
    </thead>
    <tbody>
    [#list applies as apply]
    <tr align="center">
     <td>${apply.clazz.crn}</td>
     <td>${apply.clazz.course.code}</td>
     <td>${(apply.examBeginAt?string("yyyy-MM-dd HH:mm"))!'--'}</td>
     <td>${apply.clazz.course.name}</td>
     <td>${(apply.reason.name)}:${apply.remark?if_exists}</td>
    </tr>
    [/#list]
    <tr >
     <td align="center">院系意见并<br>盖章</td>
     <td colspan="4"></td>
    </tr>
    <tr >
     <td align="center">教学主管部门<br>意见</td>
     <td colspan="4"></td>
    </tr>
    </tbody>
  <table>
[@b.foot/]

