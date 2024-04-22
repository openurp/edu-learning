[@b.card class="card-primary card-outline"]
  [@b.card_header]
    <h3 class="card-title">
      <i class="fa-solid fa-list mr-1"></i> 课内资料和附件<span class="badge badge-success">${materials?size}</span>
    </h3>
  [/@]

  [@b.card_body]
    <table class="table table-hover table-sm table-striped">
      <thead>
        <td>序号</td>
        <td>名称</td>
        <td>更新日期</td>
      </thead>
      <tbody>
      [#list materials?sort_by(["updatedAt"])?reverse as material]
        <tr>
          <td>${material_index+1}</td>
          <td>[#if material.filePath??]
                [@b.a href="!download?material.id="+material.id target="_blank"]${material.name} <i class="fa-solid fa-paperclip"></i>[/@]
              [#else]
                <a href="${material.url}" target="_blank">${material.name}</a>
              [/#if]
          </td>
          <td><span style="font-size:0.8rem;color: #999;">${material.updatedAt?string("yyyy-MM-dd HH:mm")}</span></td>
        </tr>
      [/#list]
      </tbody>
    </table>
  [/@]
[/@]
