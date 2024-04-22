[#ftl/]
<link id="jquery_theme_link" rel="stylesheet" href="${b.base}/static/css/mobile.css?rn=5" type="text/css"/>
<div class="mobile mobile_content">
  <div class="m-head">${auditPlanResult.std.name}的计划完成情况</div>
  <div class="m-body">
    <div class="m-item"><span class="m-item-title">一、基础信息</span><span class="m-item-more fa fa-angle-left pull-right menu-open"></span></div>
    <div class="m-content">
      <div class="m-line"><span class="l-caption">学生：</span><span class="l-value">${auditPlanResult.std.code} ${auditPlanResult.std.name}</span></div>
      <div class="m-line"><span class="l-caption">年级：</span><span class="l-value">${auditPlanResult.std.state.grade}</span></div>
      <div class="m-line"><span class="l-caption">培养层次：</span><span class="l-value">${auditPlanResult.std.level.name}</span></div>
      <div class="m-line"><span class="l-caption">院系：</span><span class="l-value">${auditPlanResult.std.state.department.name}</span></div>
      <div class="m-line"><span class="l-caption">专业/方向：</span><span class="l-value">${auditPlanResult.std.state.major.name}${("/" + auditPlanResult.std.state.direction.name)!}</span></div>
      <div class="m-line"><span class="l-caption">要求学分/实修学分：</span><span class="l-value">${auditPlanResult.requiredCredits}&nbsp;/&nbsp;${auditPlanResult.passedCredits}</span></div>
      [#if (auditPlanResult.gpa)?default(0)>0]<div class="m-line"><span class="l-caption">GPA：</span><span class="l-value">${(auditPlanResult.gpa)?default("0")}</span></div>[/#if]
      [#if auditPlanResult.passed]<div class="m-line"><span class="l-caption">审核结果：</span><span class="l-value">通过</span></div>[/#if]
      <div class="m-line"><span class="l-caption">审核时间：</span><span class="l-value">${(auditPlanResult.updatedAt?string('yyyy-MM-dd HH:mm:ss'))!}</span></div>
    </div>
    <div class="m-item"><span class="m-item-title">二、具体情况</span><span class="m-item-more fa fa-angle-left pull-right menu-open"></span></div>
    <div class="m-content">
      [#list auditPlanResult.groupResults?sort_by('indexno') as group]
      <div class="m-group">
        <span class="l-group-title">${group.indexno}.${group.name}<br>
          <span style="font-weight: normal">要求${group.requiredCredits}分,完成${group.passedCredits}分
          [#if group.convertedCredits gt 0][转换<span class="en_char">${group.convertedCredits}</span>学分][/#if]
          [#if group.passed]
            ,通过
          [#else]
            [#if group.requiredCredits > group.passedCredits + group.convertedCredits],
            <span style="color:red">缺${group.requiredCredits - group.passedCredits - group.convertedCredits}分</span>
            [/#if]
          [/#if]
          </span>
        </span>
        [#if group.courseResults?size>0]<span class="l-group-more fa fa-angle-left pull-right"></span>[/#if]
      </div>
      <div class="m-group-rows close">
        [#list group.courseResults?sort_by(["course","code"]) as courseResult]
        <div class="m-line m-multi-row"><span class="l-no">${courseResult_index + 1})</span><span class="l-caption">${courseResult.course.name}</span><span class="l-value"><span class="en_char">${courseResult.course.getCredits(auditPlanResult.std.level)}</span>分,<span class="en_char">${(courseResult.scores?trim)!"--"}</span>${("<br>备注：" + courseResult.remark)!}</span></div>
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
