[#ftl/]
<div class="mobile mobile_content">
  <div class="m-head">${planAuditResult.std.name}的计划完成情况</div>
  <div class="m-body">
    <div class="m-item"><span class="m-item-title">一、基础信息</span><span class="m-item-more fa fa-angle-left pull-right menu-open"></span></div>
    <div class="m-content">
      <div class="m-line"><span class="l-caption">学号：</span><span class="l-value">${planAuditResult.std.code}</span></div>
      <div class="m-line"><span class="l-caption">姓名：</span><span class="l-value">${planAuditResult.std.name}</span></div>
      <div class="m-line"><span class="l-caption">年级：</span><span class="l-value">${planAuditResult.std.state.grade}</span></div>
      <div class="m-line"><span class="l-caption">培养层次：</span><span class="l-value">${planAuditResult.std.level.name}</span></div>
      <div class="m-line"><span class="l-caption">学生类别：</span><span class="l-value">${planAuditResult.std.stdType.name}</span></div>
      <div class="m-line"><span class="l-caption">院系：</span><span class="l-value">${planAuditResult.std.state.department.name}</span></div>
      <div class="m-line"><span class="l-caption">专业/方向：</span><span class="l-value">${planAuditResult.std.state.major.name}${("/" + planAuditResult.std.state.direction.name)!}</span></div>
      <div class="m-line"><span class="l-caption">要求学分/实修学分：</span><span class="l-value">${planAuditResult.auditStat.requiredCredits}&nbsp;/&nbsp;${planAuditResult.auditStat.passedCredits}</span></div>
      <div class="m-line"><span class="l-caption">GPA：</span><span class="l-value">${(planAuditResult.gpa)?default("0")}</span></div>
      [#if planAuditResult.archived]
      <div class="m-line"><span class="l-caption">院系意见：</span><span class="l-value">${(planAuditResult.departOpinion)!}</span></div>
      <div class="m-line"><span class="l-caption">主管部门意见：</span><span class="l-value">${(planAuditResult.finalOpinion)!}</span></div>
      [/#if]
      <div class="m-line"><span class="l-caption">审核结果：</span><span class="l-value">${planAuditResult.passed?string("通过","<font color='red'>未通过</font>")}&nbsp;${(planAuditResult.partial?string('预审,有在读课程',''))!}</span></div>
      <div class="m-line"><span class="l-caption">审核时间：</span><span class="l-value">${(planAuditResult.updatedAt?string('yyyy-MM-dd HH:mm:ss'))!}</span></div>
    </div>
    <div class="m-item"><span class="m-item-title">二、具体情况</span><span class="m-item-more fa fa-angle-left pull-right menu-open"></span></div>
    <div class="m-content">
      [#list planAuditResult.groupResults?sort_by('indexno') as group]
      <div class="m-group">
        <span class="l-group-title">${group.indexno}.${group.name}<br>
          <span style="font-weight: normal">要求${group.auditStat.requiredCredits}分,完成${group.auditStat.passedCredits}分
          [#if group.auditStat.convertedCredits gt 0][转换<span class="en_char">${group.auditStat.convertedCredits}</span>学分][/#if],
          [#if group.passed]
            通过
          [#else]
            <span style="color:red">未通过</span>
            [#if group.auditStat.requiredCredits > group.auditStat.passedCredits + group.auditStat.convertedCredits],
            <span style="color:red">缺${group.auditStat.requiredCredits - group.auditStat.passedCredits - group.auditStat.convertedCredits}分</span>
            [/#if]
            [#if group.auditStat.requiredCount > group.auditStat.passedCount]
             ,<span style="color:red">缺${group.auditStat.requiredCount - group.auditStat.passedCount}门</span>
            [/#if]
          [/#if]
          </span>
        </span>
        [#if group.courseResults?size>0]<span class="l-group-more fa fa-angle-left pull-right"></span>[/#if]
        [#if (group.children?size>0)]
        <div class="l-group-remark">[#if (group.groupRelation.relation)?default("and")!="and"](所有子项至少一项满足要求)[/#if]</div>
        [/#if]
      </div>
      <div class="m-group-rows close">
        [#list group.courseResults?sort_by(["course","code"]) as courseResult]
        <div class="m-line m-multi-row"><span class="l-no">${courseResult_index + 1})</span><span class="l-caption">${courseResult.course.name}</span><span class="l-value"><span class="en_char">${courseResult.course.defaultCredits}</span>分,<span class="en_char">${(courseResult.scores?trim)!"--"}</span> ${courseResult.passed?string("通过", "<span style=\"color:red\">未过</span>")}</span>${("<br>备注：" + courseResult.remark)!}</span></div>
        [/#list]
      </div>
      [/#list]
    </div>
  </div>
</div>
<script>
  $(function() {
    function init(objMap) {
      objMap.mItemObj.click(function() {
        var moreObj = $(this).find(".m-item-more");
        if (moreObj[0].className.split(" ").includes("menu-open")) {
          moreObj.removeClass("menu-open");
          $(this).next().addClass("close");
        } else {
          moreObj.addClass("menu-open");
          $(this).next().removeClass("close");
        }
      });

      objMap.mGroupObj.click(function() {
        var moreObj = $(this).find(".l-group-more");
        if (moreObj[0].className.split(" ").includes("menu-open")) {
          moreObj.removeClass("menu-open");
          $(this).next().addClass("close");
        } else {
          moreObj.addClass("menu-open");
          $(this).next().removeClass("close");
        }
      });
    }

    $(document).ready(function() {
      init({
        "mItemObj": $(".m-item"),
        "mGroupObj": $(".m-group")
      });
      document.title = "计划完成情况";
    });
  });
</script>
