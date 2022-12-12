[#ftl]
[@b.grid items=taskList?sort_by(["course","code"]) var="clazz" sortable="false" style="border:0.5px solid #006CB2"]
  [@b.row]
    [@b.col width="5%" title="序号"]${clazz_index+1}[/@]
    [@b.col width="8%"  property="crn" title="课程序号"]${(clazz.crn)!}[/@]
    [@b.col width="10%" property="course.code" title="课程代码"/]
    [@b.col width="23%" property="course.name" title="课程名称"]
      [#if enableLinkCourseInfo]
       <a href="${ems.base}/edu/course/info/${clazz.course.id}" target="_blank">${clazz.course.name}</a>
      [#else]
        ${clazz.course.name}
      [/#if]
    [/@]
    [@b.col width="5%"  title="学分"]
      ${clazz.course.getCredits(student.level)}
    [/@]
    [@b.col width="15%" property="courseType.name" title="课程类别" /]
    [@b.col width="10%" title="授课教师"][@getTeacherNames clazz.teachers/][/@]
    [@b.col width="12%" title="第一次上课日期"]
      [#if table.timePublished]${(clazz.schedule.firstDate?string("yyyy-MM-dd"))!}[#else]尚未发布[/#if]
    [/@]
    [@b.col width="12%" property="remark" title="备注"]
       ${clazz.remark!}
      [#list clazz.schedule.sessions as s]${(s.places)!}[#sep]&nbsp;[/#list]
    [/@]
  [/@]
[/@]
