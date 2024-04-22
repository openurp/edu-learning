[#assign project = student.project/]
  <div class="jumbotron notprint" style="margin-bottom: 0px;">
    <h4>计划完成情况需要你的确认</h4>
    <p>为了让${graduateOn?string('YYYY')}届毕业生顺利毕业，核实每个同学的实际学业进度，需要确认你的培养计划的完成情况。请仔细核对计划内各组的完成学分，如有问题，联系[#if project.administration2nd??]${project.administration2nd}或[/#if]${project.administration}。</p>
    <p>
      [#if planResultCheck??]
        [#if planResultCheck.owedCredits!=(auditPlanResult.owedCredits)!0]
         <a href="javascript:void(0)" class="btn btn-sm btn-outline-primary" onclick="confirmResult()">我已经核对每个课程类别的完成学分，并对各个课程的完成情况没有异议，现在确认！</a>
        [/#if]
      [#else]
        <a href="javascript:void(0)" class="btn btn-sm btn-outline-primary" onclick="confirmResult()">我已经核对每个课程类别的完成学分，并对各个课程的完成情况没有异议，现在确认！</a>
      [/#if]
    </p>
    [#if planResultCheck??]
    <p class="text-muted">
      上次的确认结果：缺${planResultCheck.owedCredits}分，时间为${planResultCheck.updatedAt?string("yyyy-MM-dd HH:mm")}
    </p>
    [/#if]
    [@b.form name="confirmForm" action="!confirm"/]
  </div>
  <script>
    function confirmResult(){
      bg.form.submit(document.confirmForm);
    }
  </script>
