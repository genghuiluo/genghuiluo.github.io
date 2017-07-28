---
layout: post
title: have a try with E-Chart
date: 2017-07-28 09:55:12 +0800
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
            grid: {
                y2: 140
            },
            xAxis: {
                data: xdata,
				axisLine:{  
                    lineStyle:{  
                        color:'white',  
                        width: 2
                    }  
                },
				axisLabel: {
				     interval: 0, //横轴信息全部显示
                     rotate: -30,
                }
            },
            yAxis: {
            	axisLine:{  
                    lineStyle:{  
                        color:'white',  
                        width: 2  
                    }  
                }
            },
            series: [{
                name: '热度',
                type: 'bar',
                itemStyle: {
                normal: {
　　　　　　　　//好，这里就是重头戏了，定义一个list，然后根据所以取得不同的值，这样就实现了，
                        color: function(params) {
                            // build a color map as your need.
                            var colorList = [
                              '#C1232B','#B5C334','#FCCE10','#E87C25','#27727B',
                               '#FE8463','#9BCA63','#FAD860','#F3A43B','#60C0DD',
                               '#D7504B','#C6E579','#F4E001','#F0805A','#26C0C0'
                            ];
                            return colorList[params.dataIndex]
                        },
　　　　　　　　　　　　　　//以下为是否显示，显示位置和显示格式的设置了
                        label: {
                            show: true,
                            position: 'top',
                            formatter: '{b}\n{c}',
                            rotate: -30
                        }
                    }
                },
　　　　　　　　//设置柱的宽度，要是数据太少，柱子太宽不美观~
　　　　　　　　barWidth: 50,
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
