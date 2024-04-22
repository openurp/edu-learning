[#ftl]
<div class="container-fluid">
[#macro display group]
  [#list group.children as child]
    [@display child/]
  [/#list]
  [#assign groupTitle]${group.courseType.name} [#if group.language??]${group.language.name}[/#if] [#if group.courseAbilityRate??]${group.courseAbilityRate.name}[/#if][/#assign]
  <tr>
    <td colspan="4" style="text-align:left;font-weight:bold">${group.indexno} ${groupTitle}</td>
  </tr>
  [#list group.planCourses as pc]
    <tr>
      <td>${pc.course.code}<input type="hidden" value="${groupTitle}" name="groupName"></td>
      <td>
        [#if enableLinkCourseInfo]
         <a href="${ems_base}/edu/course/info/${pc.course.id}" target="_blank">${pc.course.name}</a>
        [#else]
          ${pc.course.name}
        [/#if]
      </td>
      <td>${pc.course.getCredits(sharePlan.level)}</td>
      <td>${pc.course.department.name}</td>
    </tr>
  [/#list]
[/#macro]
  <div style="text-align:center;vnd.ms-excel.numberformat:@;width:90%;margin:auto">
    <h5>${sharePlan.name} </h5>
    <div class="input-group input-group-sm" style="width: 50%;margin: auto;">
      <input class="form-control form-control-navbar" type="search" name="q" id="course_query_item" value=""
             aria-label="Search" placeholder="输入关键词，课程类型、课程代码或名称" autofocus="autofocus"
             onchange="return search(this.value);">
      <div class="input-group-append">
        <button class="input-group-text" type="submit" onclick="return search(document.getElementById('course_query_item').value);">
          <i class="fas fa-search"></i>
        </button>
      </div>
    </div>
    <div class="grid-content">
      <table class="grid-table" id="share_plan_table">
        <thead class="grid-head">
          <tr>
            <td width="10%">课程代码</td>
            <td>课程名称</td>
            <td width="10%">学分</td>
            <td width="20%">开课院系</td>
          </tr>
        </thead>
        <tbody>
        [#list sharePlan.groups?sort_by("indexno") as group]
          [#if !(group.parent??)]
            [@display group/]
          [/#if]
        [/#list]
        </tbody>
      </table>
    </div>
  </div>
</div>
<script>
   function search(q){
    jQuery("#share_plan_table tbody tr").each(function(i,e){
      var tds = jQuery(e).children("td");
      var matched = (q=="") || tds.length<2;
      if(!matched){
        for(var idx=0;idx < tds.length;idx++){
          if(q=='' || tds[idx].innerHTML.indexOf(q)>-1){
            matched=true;
            break;
          }
        }
      }
      if(matched){
        jQuery(e).show();
      }else{
        jQuery(e).hide();
      }
    });
    return false;
   }
</script>
