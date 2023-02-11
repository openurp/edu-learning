[#ftl/]
<div class="mobile">
  <div class="m-head">${student.name}所有学期成绩</div>
  <div class="m-content">
    <div class="m-group-rows">
      [#list grades as grade]
      <div class="m-line m-multi-row"><span class="l-no">${grade_index + 1}.</span><span class="l-caption">${grade.course.name}</span><br><span class="l-value">${grade.courseType.name}，<span class="en_char">${grade.semester.schoolYear}</span>${grade.semester.name}</span>，<span class="en_char">${grade.course.defaultCredits}</span>学分，[#if grade.published]<span class="en_char${grade.passed?string(" passed"," unpass")}">${grade.scoreText!"--"}</span>[#else]<span class="noresult">${b.text('grade.notPublished')}</span>[/#if]</div>
      [/#list]
    </div>
  </div>
</div>
<script>
  $(function() {
    $(document).ready(function() {
      document.title = "所有学期成绩";
    });
  });
</script>
