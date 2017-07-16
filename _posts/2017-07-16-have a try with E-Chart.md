---
layout: post
title: have a try with E-Chart
date: 2017-07-16 23:52:20 +0800
categories: web
---


<div id="main" style="width: 100%; min-height: 400px"></div>
<script type="text/javascript">
// 基于准备好的dom，初始化echarts实例
var myChart = echarts.init(document.getElementById('main'));

function updateChart() {
$.getJSON('https://dev.genghuiluo.cn/feed/weibo/realtimehot.json', function(data){


		var xdata = [];
		var ydata = [];

		$.each( data, function( key, val ) {
			xdata.push(val.key_text);	
			ydata.push(val.point);	
        });

  	        var option = {
            title: {
                text: '微博实时 top10 关键字(最近一周)',
				textStyle: {  
        			fontWeight: 'normal',              //标题颜色  
        			color: 'white'  
    			} 
            },
            tooltip: {},
            legend: {
                data:['热度']
            },
            xAxis: {
                data: xdata,
				axisLine:{  
                    lineStyle:{  
                        color:'green',  
                        width:1  
                    }  
                },
				axisLabel: {
				     interval: 0, //横轴信息全部显示
                }
            },
            yAxis: {
            	axisLine:{  
                    lineStyle:{  
                        color:'green',  
                        width:1  
                    }  
                }
            },
            series: [{
                name: '热度',
                type: 'bar',
                data: ydata,
            }]
        };
  
	myChart.setOption(option);

	})
}

$(document).ready(function() {
    updateChart();
});

var refresh=window.setInterval(function(){
  // call your function here
    updateChart();	
},300000);        

</script>
