---
layout: post
title: Weibo Hotkey Dashboard
date: 2018-01-06 21:03:33 +0800
categories: web
---

<div id="weibo_1w" style="width: 100%; min-height: 600px"></div>
<div id="weibo_3d" style="width: 100%; min-height: 600px"></div>
<div id="weibo_1d" style="width: 100%; min-height: 600px"></div>
<script type="text/javascript">
// 基于准备好的dom，初始化echarts实例
var weibo_1w_chart = echarts.init(document.getElementById('weibo_1w'));
var weibo_3d_chart = echarts.init(document.getElementById('weibo_3d'));
var weibo_1d_chart = echarts.init(document.getElementById('weibo_1d'));

function updateChart(day,element,title) {
$.getJSON('http://feed.genghuiluo.cn/weibo/realtimehot.json?day='+day, function(data){


	var xdata = [];
	var ydata = [];

	$.each( data, function( key, val ) {
			xdata.push(val.key_text);	
			ydata.push(val.point);	
        });

  	var option = {
            title: {
                text: title,
				textStyle: {  
        			fontWeight: 'normal',              //标题颜色  
        			color: 'black'  
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
                        color:'black',  
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
                        color:'black',  
                        width: 2  
                    }  
                },
                splitNumber: 10
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
                            formatter: '{c}\n'
                        }
                    }
                },
　　　　　　　　//设置柱的宽度，要是数据太少，柱子太宽不美观~
　　　　　　　　barWidth: 50,
                data: ydata,
            }]
        };
  
	element.setOption(option);

	})
}

$(document).ready(function() {
    updateChart(7,weibo_1w_chart,'微博实时 top10 关键字(最近1周)');
    updateChart(3,weibo_3d_chart,'微博实时 top10 关键字(最近3天)');
    updateChart(1,weibo_1d_chart,'微博实时 top10 关键字(最近1天)');
});

//refresh each 300s
var refresh=window.setInterval(function(){
    updateChart(7,weibo_1w_chart,'微博实时 top10 关键字(最近1周)');
    updateChart(3,weibo_3d_chart,'微博实时 top10 关键字(最近3天)');
    updateChart(1,weibo_1d_chart,'微博实时 top10 关键字(最近1天)');
},300000);        

</script>
