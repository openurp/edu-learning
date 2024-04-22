<style>
  .scalable_img{
   transition: all 0.2s linear;
  }
  .scalable_img:hover{
     transform:scale(3.0);
     transition: all 0.2s linear;
   }
</style>
  [@b.card class="card-primary card-outline" style="margin-bottom: 0px;"]
    [@b.card_header]
       <h3 class="card-title">
         <i class="fa-solid fa-bullhorn"></i> 通知
       </h3>
    [/@]
    [@b.card_body style="padding:0px"]
      [#if notices?size==0]<p class="text-muted">暂无通知</p>[/#if]
    [/@]
  [/@]
  [#list notices?sort_by("updatedAt")?reverse as notice]
    <div class="card">
      <div class="card-header" style="padding-bottom: 0px;">
        ${notice.title}&nbsp;<span style="font-size:0.8rem;color: #999;">${notice.updatedAt?string("yy-MM-dd HH:mm")}</span>
      </div>
      <div class="card-body" style="padding-top: 5px;">
         <p class="card-text">${notice.contents}</p>
         [#if notice.files?size>0]
            附件：[#list notice.files as f]
              [@b.a href="!download?noticeFile.id="+f.id target="_blank"]<i class="fa-solid fa-paperclip"></i> ${f.name}[/@]
              [#if f.mediaType?starts_with("image")]<image class="scalable_img" src="${b.url('!download?noticeFile.id='+f.id)}" width="40px"/>[/#if]
            [/#list]
         [/#if]
      </div>
    </div>
  [/#list]
