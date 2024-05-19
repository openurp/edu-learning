  [@b.card class="card-primary card-outline" style="margin-bottom: 0px;"]
    [@b.card_header]
       <h3 class="card-title">
         <i class="fa-solid fa-list mr-1"></i>  课程详细安排
       </h3>
    [/@]
    [@b.card_body style="padding:0px"]
      [#if !plan??]<p class="text-muted" style="padding-left: 20px;">暂无</p>
      [#else]
      <table class="table table-hover table-sm table-striped" style="font-size: 13px;">
        <thead>
          <th width="6%">序号</th>
          <th width="94%">上课内容</th>
        </thead>
        <tbody>
        [#list plan.lessons?sort_by('idx') as lesson]
          <tr>
            <td>${lesson.idx}</td>
            <td>${(lesson.contents!"")?replace("\n","<br>")}</td>
          </tr>
        [/#list]
        </tbody>
      </table>
      [/#if]
    [/@]
  [/@]
