[#ftl]
[@b.head/]
<link id="jquery_theme_link" rel="stylesheet" href="${b.base}/static/css/mobile.css?rn=5" type="text/css"/>
<div class="container-fluid pc_content">
  [@b.toolbar title="课程成绩"]
    bar.addBack("${b.text("action.back")}");
  [/@]
  [#include "grades_simple.ftl"/]
</div>
<div class="mobile_content">
[#include "grades_mobile.ftl"/]
</div>
[@b.foot/]
