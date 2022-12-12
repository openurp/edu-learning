[#ftl]
[@b.head/]
[@b.toolbar title="课程班级通知"]
  bar.addBack("${b.text("action.back")}");
[/@]
  <style>
    .scalable_img{
       transition: all 0.2s linear;
    }
   .scalable_img:hover{
     transform:scale(3.0);
     transition: all 0.2s linear;
    }
  </style>
  <div class="box-body no-padding">
    <div class="mailbox-read-info">
      <h3>【${notice.clazz.crn}】${notice.clazz.courseName}:${notice.title}</h3>
      <h6><span class="mailbox-read-time pull-right">发布日期：${notice.updatedAt?string('yyyy-MM-dd')}</span></h6>
    </div>
    <div class="mailbox-read-message">
      ${notice.contents}
    </div>
    [#if notice.files?size>0]
    <div class="mailbox-read-message">
      <ul>附件列表
      [#list notice.files as f]
      <li>
        [@b.a href="!download?noticeFile.id="+f.id target="_blank"]${f.name}[/@]
        [#if f.mediaType?starts_with("image")]<image class="scalable_img" src="${b.url('!download?noticeFile.id='+f.id)}" width="40px"/>[/#if]
      </li>
      [/#list]
      </ul>
    </div>
    [/#if]
  </div>
[@b.foot/]
