[#ftl/]
[@b.head /]

[@b.toolbar title="缓考申请"]
  bar.addItem("提交", "save()");
  bar.addBack();
[/@]

[@b.form name="submitApplyForm" action="!submitApply" theme="list"]
  [@b.field label="学生"]
    ${examTaker.std.code} ${examTaker.std.name}
  [/@]
  [@b.field label="课程"]
    ${examTaker.clazz.crn} ${examTaker.clazz.course.code} ${examTaker.clazz.course.name}
  [/@]
  [@b.textfield name="apply.mobile" label="移动电话" value=apply.mobile! required="true"/]
  [@b.select name="apply.reason.id" label="缓考原因" value=apply.reason! required="true" items=reasons value=apply.reason!/]
  [@b.textarea name="apply.remark" label="申请理由" value=apply.remark! required="true" maxlength="200" cols="80" rows="5" comment="200字以内"/]
  [@b.formfoot]
    <input type="hidden" name="examTakerId" value="${examTaker.id}">
    [@b.submit /]
  [/@]
[/@]
[@b.foot/]
