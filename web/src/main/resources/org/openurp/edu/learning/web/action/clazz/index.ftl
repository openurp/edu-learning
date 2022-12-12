[@b.head/]
<style>
  body{
    font-size:14px;
  }
</style>
<div class="container-fluid">
  [#include "nav.ftl"/]
  <div class="row">
    <div class="col-md-3">
      [#include "teachers.ftl"/]
      [#include "schedule.ftl"/]
    </div>

    <div class="col-md-6">
      [@b.div href="!notices?clazz.id="+clazz.id/]
      [@b.div href="!teachingPlan?clazz.id="+clazz.id/]
      [@b.div href="!materials?clazz.id="+clazz.id/]
    </div>

    <div class="col-md-3">
      [@b.div href="!bulletin?clazz.id="+clazz.id/]
      [#include "course.ftl"/]
      [#include "exam_grade.ftl"/]
    </div>
  </div>
</div>
[@b.foot/]
