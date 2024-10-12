[#ftl]
[@b.head/]
[#include "/org/openurp/starter/web/components/multi-std-nav.ftl"/]
<div class="container-fluid">
[@b.toolbar title="期末考试安排"/]
[@base.semester_bar value=semester!]
  [#if DeferApplyEnabled]<div style="float:right">[@b.a href="!printApply" target="_blank"]打印缓考申请[/@]</div>[/#if]
[/@]
[@b.messages slash='3'/]

<table width="100%" class="grid-table">
  <thead class="grid-head">
    <tr>
      <td width="7%">课程序号</td>
      <td>课程名称</td>
      <td width="15%">课程类别</td>
      <td width="20%">考试时间</td>
      <td width="15%">考场[#if showSeatNo](座位号)[/#if]</td>
      <td width="8%">考试情况</td>
      [#if DeferApplyEnabled]<td width="15%">缓考申请</td>[/#if]
    </tr>
  </thead>
  <tbody>
  [#list courseTakers?sort_by(["clazz","crn"]) as taker]
  [#if taker_index%2==1][#assign class="grayStyle"][/#if]
  [#if taker_index%2==0][#assign class="brightStyle"][/#if]
  <tr class="${class}" align="center" height="23px">
    <td>${(taker.clazz.crn)!}</td>
    <td>${(taker.clazz.course.name)!}</td>
    <td>${(taker.clazz.courseType.name)!}</td>
    [#if finalTakers.get(taker)?? ]
      [#assign examTaker = finalTakers.get(taker) /]
      [#if finalTakers.get(taker).activity?? && finalTakers.get(taker).activity.examOn??]
        [#assign activity = finalTakers.get(taker).activity]
        <td>
          [#if activity.publishState.timePublished]
            [#if activity.examOn??]${activity.examOn?string('yyyy-MM-dd')}&nbsp;&nbsp;[/#if][#if activity.beginAt?? && activity.endAt??]${(activity.beginAt)!}~${(activity.endAt)!}[/#if]
          [#else]
            <font color="BBC4C3">[尚未发布]</font>
          [/#if]
        </td>
        <td>[#if activity.publishState.roomPublished]${(examTaker.examRoom.room.name)!}[#if showSeatNo](${examTaker.seatNo})[/#if][#else]<font color="BBC4C3">[尚未发布]</font>[/#if]</td>
        <td>${(examTaker.examStatus.name)!}</td>
        [#if DeferApplyEnabled]
        <td>
          [#if applyMap[examTaker.clazz.id?string+"_"+examTaker.examType.id?string]??]
            [@b.a href="!printApply?examApplyId=${examTaker.id}" target="_blank"]查看[/@]
            [#assign apply = applyMap[examTaker.clazz.id?string+"_"+examTaker.examType.id?string]/]
            [#if apply.passed??]
              [#if !apply.passed]
                [@b.a href="!editApply?examTakerId=${examTaker.id}"]重新申请[/@]
                [@b.a href="!cancelApply?examApplyId=${examTaker.id}"]撤销[/@]
              [/#if]
              <b>${(apply.passed?string("<font color='green'>通过</font>","<font color='red'>不通过</font>"))!}</b>
            [#else]
              [@b.a href="!cancelApply?applyId=${apply.id}" onclick="return bg.Go(this,null,'确定撤销?')"]撤销[/@]
              <b>已提交</b>
            [/#if]
          [#else]
            [#if examTaker.examStatus.id == 1]
              [@b.a href="!editApply?examTakerId=${examTaker.id}"]申请[/@]
            [/#if]
          [/#if]
        </td>
        [/#if]
      [#else]
        <td colspan="3"><font color="BBC4C3">[尚未安排]</font></td>
        [#if DeferApplyEnabled]<td></td>[/#if]
      [/#if]
    [#else]
       <td colspan="3"><font color="BBC4C3">[无考试记录]</font></td>
       [#if DeferApplyEnabled]<td></td>[/#if]
    [/#if]
  </tr>
  [/#list]
  </tbody>
</table>

[#if finalExamNotice??]<div class="callout callout-info">${finalExamNotice.studentNotice!}</div>[/#if]

[#if otherTakers?size>0]
<div style="height: 30px;"></div>
[@b.toolbar title="补缓考试安排"/]
<table width="100%" class="grid-table">
  <thead class="grid-head">
    <tr align="center">
      <td width="10%">课程序号</td>
      <td width="21%">课程名称</td>
      <td width="18%">课程类别</td>
      <td width="20%">考试时间</td>
      <td width="18%">考场[#if showSeatNo](座位号)[/#if]</td>
      <td width="13%">考试情况</td>
    </tr>
  </thead>
  <tbody>
  [#list otherTakers?keys?sort_by(["clazz","crn"]) as taker]
    [#if taker_index%2==1][#assign class="grayStyle"][/#if]
    [#if taker_index%2==0][#assign class="brightStyle"][/#if]
    <tr class="${class}" align="center" height="23px">
      <td>${(taker.clazz.crn)!}</td>
      <td>${(taker.clazz.course.name)!}</td>
      <td>${(taker.clazz.courseType.name)!}</td>
      [#assign examTaker = otherTakers.get(taker) /]
      [#if examTaker.activity??]
        [#assign activity=examTaker.activity/]
        <td>
          [#if activity.publishState.timePublished]
            ${(activity.examOn?string('yyyy-MM-dd'))!}[#if activity.examOn??]&nbsp;&nbsp;[/#if][#if activity.beginAt?? && activity.endAt??]${activity.beginAt}~${activity.endAt}[/#if]
          [#else]
            <font color="BBC4C3">[尚未发布]</font>
          [/#if]
        </td>
        <td>[#if activity.publishState.roomPublished]${(examTaker.examRoom.room.name)!}[#if showSeatNo](${examTaker.seatNo})[/#if][#else]<font color="BBC4C3">[尚未发布]</font>[/#if]</td>
        <td>${(examTaker.examStatus.name)!}</td>
      [#else]
        <td colspan="3"><font color="BBC4C3">[尚未安排]</font></td>
      [/#if]
    </tr>
  [/#list]
  </tbody>
</table>

[#if otherExamNotice??]<div class="callout callout-info">${otherExamNotice.studentNotice!}</div>[/#if]
[/#if]
</div>
[@b.foot/]
