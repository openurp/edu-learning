<!DOCTYPE html>
<html lang="zh_CN">
  <head>
    <title></title>
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta http-equiv="pragma" content="no-cache"/>
    <meta http-equiv="cache-control" content="no-cache"/>
    <meta http-equiv="expires" content="0"/>
    <meta http-equiv="content-style-type" content="text/css"/>
    <meta http-equiv="content-script-type" content="text/javascript"/>
 </head>
 <body style="padding:5mm 10mm 0mm 10mm;width: 180mm;margin: auto;margin:auto;">
     <style>
       .contents{
          text-align:left;
          margin:0px;
          font-size:15pt;
          line-height:60px;
          letter-spacing:1px;
          text-align:justify;
          text-justify:inter-ideograph;
          font-family: 宋体;
          word-break:break-all;
       }
        .footer-div {
          font-family:'Arial';
          font-size:10pt;
        }
     </style>
     <div style="height:922px;text-align:center;">
       <img src="https://courses.lixin.edu.cn/static/local/default/images/lixin_blue_logo.png" style="width:70%;margin-top: 20px;">
       <div style="border-bottom:1px solid #000;"></div>
       <div style="margin-top:50px;"><h1 ALIGN="CENTER"><span style="letter-spacing:8px;font-family: 宋体">成 绩 排 名 证 明</span></h1></div>
       <p>&nbsp;</p>
       <div style="text-align:left;text-indent:3em;">
        [#assign std=stdGpa.std/]
<p  class="contents">
[#assign squadName]${(std.squad.name)!'--'}[/#assign]
[#assign squadName]${squadName?replace('${std.grade.code}级','')}[/#assign]
${std.name}，${std.gender.name}，学号${std.code}，系我校${std.grade.code}级${std.department.name}${squadName}学生。${std.grade.code}级${std.major.name}专业
共${majorStdCount}人，该同学专业排名是第${rank}名。
</p>
        <p class="contents">特此证明。</p>
        <p>&nbsp;</p>
        <p>&nbsp;</p>
       </div>
       <div style="float:right;text-align: right;">
         <p style="margin-top:40px"><span style="font-size:16pt;font-family: 宋体"><b>${std.project.school.name}</b></span></p>
         <p style="margin-top:10px"><span style="font-size:16pt ;font-family:宋体"><b>教务处</b></span></p>
         <p style="margin-top:20px"><span style="font-size:16pt;font-family: 宋体"><b>${b.now?string("yyyy年MM月dd日")}</b></span></p>
         <img src="https://xyzm.lixin.edu.cn/static/local/default/images/grade_sig.jpg" style="height:42mm;width:42mm;margin-left: 30mm;margin-top: -130px;">
       </div>
    </div>
</body>
</html>
