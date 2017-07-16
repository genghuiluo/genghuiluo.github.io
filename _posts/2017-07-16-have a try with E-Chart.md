---
layout: post
title: have a try with E-Chart
date: 2017-07-16 23:22:03 +0800
categories: web
---


<div id="main" style="width:100%"></div>
<script type="text/javascript">
        // 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById('main'));
        
       
var refresh=window.setInterval(function(){
  // call your function here
	//location.reload();
	$.getJSON('https://dev.genghuiluo.cn/feed/weibo/realtimehot.json', function(data){


		var xdata = [];
		var ydata = [];

		$.each( data, function( key, val ) {
			xdata.push(val.key_text);	
			ydata.push(val.point);	
        });

  	        var option = {
            title: {
                text: '微博实时 top10 关键字(最近一周)'
            },
            tooltip: {},
            legend: {
                data:['热度']
            },
            xAxis: {
                data: xdata
            },
            yAxis: {},
            series: [{
                name: '热度',
                type: 'bar',
                data: ydata
            }]
        };
  
	myChart.setOption(option);

	})	
},300000);        


</script>
