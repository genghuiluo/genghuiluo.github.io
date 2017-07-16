---
layout: post
title: have a try with E-Chart
date: 2017-07-16 23:00:20 +0800
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


		var xdata = [];
		var ydata = [];

		$.each( data, function( key, val ) {
			xdata.push(val.key_text);	
			ydata.push(val.point);	
        });

  	        var option = {
            title: {
                text: 'ECharts 入门示例'
            },
            tooltip: {},
            legend: {
                data:['销量']
            },
            xAxis: {
                data: xdata
            },
            yAxis: {},
            series: [{
                name: '销量',
                type: 'bar',
                data: ydata
            }]
        };
  
	myChart.setOption(option);

	})	
},3000);        


</script>
