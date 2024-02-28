[#ftl]
[#if stdGpa??][#include "stat.ftl"/][/#if]
[#assign gradeTypes=gradeTypes?sort_by('code')/]
[#if gradeTypes?size>0]
  [#assign width=16/(gradeTypes?size)]
[#else]
  [#assign width=16]
[/#if]

[@b.grid items=grades var="grade" filterable="false" class="border-1px border-colored"]
  [@b.row]
    [@b.col title="序号" width="5%"]${grade_index+1}[/@]
    [@b.col title="学年学期" width="8%"]${grade.semester.schoolYear} ${grade.semester.name}[/@]
    [@b.col title="课程代码" width="9%"]${(grade.course.code)!}[/@]
    [@b.col title="课程序号" width="7%"]${(grade.crn)!}[/@]
    [@b.col title="课程名称" width="20%"]${grade.course.name}[/@]
    [@b.col title="课程类别" width="12%"]${grade.courseType.name}[/@]
    [@b.col title="修读类别" width="8%"]
      [#if grade.courseTakeType?? && grade.courseTakeType.id !=1]
      <span style="color:red;">${grade.courseTakeType.name}</span>
      [#else]
      ${grade.courseTakeType.name}
      [/#if]
      [#if grade.freeListening]<sup>免听</sup>[/#if][#t/]
    [/@]
    [@b.col title="学分" width="5%"]${(grade.course.getCredits(grade.std.level))!}[/@]
    [#if grade?exists]
    [#list gradeTypes as gradeType]
    [#assign examStyle][#if grade.published]${grade.passed?string("","color:red")}[/#if][/#assign]
    [#assign gradeTypeTitle]${gradeType.name}[/#assign]
    [@b.col title=gradeTypeTitle style="${examStyle!}"]
        [#assign examGrade=grade.getGrade(gradeType)!"null"]
        [#if examGrade!="null" && examGrade.published]
          ${examGrade.scoreText!'--'}
          [#if (examGrade.examStatus.id)?default(1)!=1]
            (${examGrade.examStatus.name})
          [/#if]
          [#if gradeType.ga && examGrade.delta ?? && examGrade.delta > 0]
            <sup>+${examGrade.delta}<sup>
          [/#if]
        [/#if]
    [/@]
    [/#list]
    [#assign style][#if grade.published]${grade.passed?string("","color:red")}[/#if][/#assign]
    [@b.col title="最终" style="${style!}" width="5%"]
      [#if grade.published]${grade.scoreText!"--"}[#else]${b.text('grade.notPublished')}[/#if]
    [/@]
    [@b.col title="绩点" width="5%"]
      [#if grade.published]${grade.gp!}[#else]${b.text('grade.notPublished')}[/#if]
    [/@]
    [/#if]
  [/@]
[/@]
<br>
