---
layout: post
title: have a try with E-Chart
date: 2017-07-16 22:54:53 +0800
categories: web
---


<div id="main" style="width: 600px;height:400px;"></div>
<script type="text/javascript">
        // 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById('main'));
        
       
var refresh=window.setInterval(function(){
  // call your function here
	//location.reload();
	$.getJSON('https://dev.genghuiluo.cn/feed/weibo/realtimehot.json', function(data){
		$.each( data, function( key, val ) {
			alert(val.key_text)	
        });
	})	
},3000);        


</script>
