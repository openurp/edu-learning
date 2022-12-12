[@b.card class="card-info card-primary card-outline"]
  [#assign title]<i class="fas fa-file-pdf"></i> 课程班级通知[/#assign]
  [@b.card_header class="border-transparent" title=title  minimal="true" closeable="true"]
  [/@]
  [@b.card_body class="p-0"]
      <table id="notice_table" class="table no-margin m-0 compact">
        <tbody>
        [#list notices as notice]
        <tr>
          <td><a href="${b.base}/notice/${notice.id}" target="_blank">【${notice.clazz.crn}】${notice.clazz.courseName}:${notice.title}</a></td>
          <td><span class="text-muted">${notice.updatedAt?string('MM-dd')}</span></td>
        </tr>
        [/#list]
        </tbody>
      </table>
    [/@]
  [/@]
