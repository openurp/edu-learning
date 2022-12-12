  [@b.card class="card-primary card-outline"]
    [@b.card_header]
      <h3 class="card-title"><i class="fa-sharp fa-solid fa-chalkboard"></i> 公告栏</h3>
    [/@]
    [@b.card_body style="padding: 0px 20px;"]
       [#if bulletin??]
        <p class="card-text">${bulletin.contents}</p>
        <p class="card-text">
          [#if bulletin.communicationChannel??]日常沟通：${bulletin.communicationChannel}[/#if]
          [#if bulletin.communicationQrcodePath??]
            <image class="scalable_img" src="${b.url('!download?bulletin.id='+bulletin.id)}" width="40px"/>
            [@b.a href="!download?bulletin.id="+bulletin.id target="_blank"]<i class="fa-solid fa-paperclip"></i>[/@]
          [/#if]
        </p>
        [#else]教师尚未填写[/#if]
    [/@]
  [/@]
