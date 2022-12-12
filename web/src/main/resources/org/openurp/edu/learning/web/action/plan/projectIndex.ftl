[#ftl]
[@b.head/]
[@b.messages /]
<link rel="stylesheet" type="text/css" href="${b.base}/static/css/plan.css?v=20220810" />
[#if plan??]
[#include "planFunctions.ftl" /]
[#assign maxTerm = plan.terms /]
[#assign terms = Parameters['terms']?default("")]
<div>
    [@b.tabs]
      [@b.tab label="培养计划"]
        [@planTitle plan/]
        [#assign numericTerm=true/]
        [#if !numericTerm]
        [#include "planInfoTableSimple.ftl"/]
        [#else]
        [#include "planInfoTableDefault.ftl"/]
        [/#if]
      [/@]
      [#if hasProgramDoc]
        [@b.tab label="培养方案" href="!programDoc?program.id="+plan.program.id/]
      [/#if]
      [@b.tab label="替代课程"]
        <div style="text-align:center;font-size:12px;vnd.ms-excel.numberformat:@;width:90%;margin:auto" >
        [#if stdAlternativeCourses?? && stdAlternativeCourses?size > 0]
          <h5>个人替代课程</h5>
          [@b.grid sortable="false" items=stdAlternativeCourses var="stdAlternativeCourse" style="border:0.5px solid #006CB2"]
              [@b.row]
                  [@b.col width="10%" title="序号"]${stdAlternativeCourse_index+1}[/@]
                  [@b.col width='45%' title="原课程代码、名称、学分"]
                      [#list stdAlternativeCourse.olds as course]${course.code} ${course.name} (${course.getCredits(student.level)})[#if course_has_next]<br>[/#if][/#list]
                  [/@]
                  [@b.col width='45%' title="替代课程代码、名称、学分"]
                      [#list stdAlternativeCourse.news as course]${course.code} ${course.name} (${course.getCredits(student.level)})[#if course_has_next]<br>[/#if][/#list]
                  [/@]
              [/@]
          [/@]
        [#else]
            暂无个人替代课程.
        [/#if]
        </div>
        <div style="text-align:center;font-size:12px;vnd.ms-excel.numberformat:@;width:90%;margin:auto">
        [#if majorAlternativeCourses?? && majorAlternativeCourses?size > 0]
          <h5>专业替代课程</h5>
          [@b.grid sortable="false" items=majorAlternativeCourses var="majorAlternativeCourse" style="border:0.5px solid #006CB2"]
            [@b.row]
              [@b.col width="10%" title="序号"]${majorAlternativeCourse_index+1}[/@]
              [@b.col width='45%' title="原课程代码、名称、学分"]
                  [#list (majorAlternativeCourse.olds)! as course]${(course.code)!} ${(course.name)!} (${(course.getCredits(student.level))!})[#if course_has_next]<br>[/#if][/#list]
              [/@]
              [@b.col width='45%' title="替代课程代码、名称、学分"]
                  [#list (majorAlternativeCourse.news)! as course]${(course.code)!} ${(course.name)!} (${(course.getCredits(student.level))!})[#if course_has_next]<br>[/#if][/#list]
              [/@]
            [/@]
          [/@]
        [#else]
            暂无专业替代课程.
        [/#if]
        </div>
        [/@]
        [#if sharePlan??]
          [@b.tab label="公共课程"]
            [#include "sharePlan.ftl"/]
          [/@]
        [/#if]
    [/@]
</div>
[#else]
<div>尚无您的培养计划</div>
[/#if]
[@b.foot/]
