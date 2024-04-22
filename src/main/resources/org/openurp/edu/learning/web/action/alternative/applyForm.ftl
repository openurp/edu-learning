[#ftl]
[@b.head /]
[@b.toolbar title="学生个人替代课程申请"]
    bar.addBack();
[/@]
<style>
  #alternativeCourseForm fieldset.listset li > label.title{
      min-width:130px;
  }
</style>
[@b.form name="alternativeCourseForm" theme="list"  action="!doApply"]
    [@b.field label="学号" required='true']${std.code} ${std.name}    [/@]
      [#if multiple_enabled]
      [@b.field label="替代说明"]
        计划内课程和替代课程，原则上是一对一选择；如果选择多门则表示多门替代一门。
      [/@]
      [/#if]
      [@b.select label="原课程(计划内)" name="originIds" items=planCourses required='true' empty="..."
                 option=r"${item.name} (${item.code} ${item.getCredits(student.level)}学分)"
                 comment="计划中的课程" style="width:500px;" chosenMin="1"]
       <option value="">...</option>
      [/@]

    [#if multiple_enabled]
      [@b.select label="替代课程(有成绩)" name="substituteIds" items=gradeCourses?sort_by('name') required='true'
                 option=r"${item.name} (${item.code} ${item.getCredits(student.level)}学分 成绩${scores.get(item)})"
                 comment="成绩中的课程" style="width:500px;" multiple="true" chosenMin="1"/]
    [#else]
      [@b.select label="替代课程(有成绩)" name="substituteIds" items=gradeCourses?sort_by('name') required='true' empty="..."
                 option=r"${item.name} (${item.code} ${item.getCredits(student.level)}学分 成绩${scores.get(item)})"
                 comment="成绩中的课程" style="width:500px;" chosenMin="1"]
        <option value="">...</option>
      [/@]
    [/#if]
    [@b.textarea name='apply.remark' label='备注' cols="46" rows="2" value="${(apply.remark?html)!}" required="true" maxlength="200" comment="最多200字"/]
    [@b.formfoot]
        <input type="hidden" name="projectId" value="${std.project.id}"/>
        [@b.submit value="action.submit" /]
    [/@]
[/@]
[@b.foot /]
