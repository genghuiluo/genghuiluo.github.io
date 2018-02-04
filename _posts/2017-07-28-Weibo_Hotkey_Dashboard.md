---
layout: post
title: Weibo Hotkey Dashboard
date: 2018-02-04 21:06:07 +0800
categories: web
---

<div id="weibo_top10" style="width: 100%; min-height: 600px"></div>
<div id="weibo_key_num" style="width: 100%; min-height: 600px"></div>
<script type="text/javascript">

// 基于准备好的dom，初始化echarts实例
var weibo_top10_chart = echarts.init(document.getElementById('weibo_top10'));
var weibo_key_num_chart = echarts.init(document.getElementById('weibo_key_num'));

function updateBarChart(element,title) {
$.getJSON('http://feed.genghuiluo.cn/weibo/top10.json', function(data){

	var xdata = [];
	var ydata = [];

	$.each( data, function( key, val ) {
		xdata.push(val.key_text);	
		ydata.push(val.on_rank_cnt);	
        });

  	var option = {
            title: {
                text: title,
		x: 'center'	
            },
            tooltip: {},
            grid: {
                y2: 140
            },
	    toolbox: {
		x: 'left',
	        feature: {
	            saveAsImage: {}
	        }
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
                	rotate: -20,
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

function updateLineChart(element,title) {
$.getJSON('http://feed.genghuiluo.cn/weibo/key_num.json', function(data){


	var xdata = [];
	var max_key_num = [];
	var large_10_max = [];
	var large_20_max = [];

	$.each( data, function( key, val ) {
		xdata.push(val.dayofweek);	
		max_key_num.push(val.max_key_num);	
		large_10_max.push(val.large_10_max);	
		large_20_max.push(val.large_20_max);	
        });

	option = {
	    title: {
	        text: title,
		x: 'center'
	    },
	    tooltip: {
	        trigger: 'axis'
	    },
	    legend: {
	        data: ['MAX','MAX_>10','MAX_>20'],
		x: 'right'
	    },
	    grid: {
	        left: '3%',
	        right: '4%',
	        bottom: '3%',
	        containLabel: true
	    },
	    toolbox: {
		x: 'left',
	        feature: {
	            saveAsImage: {}
	        }
	    },
	    xAxis: {
	        type: 'category',
	        data: xdata
	    },
	    yAxis: {
	        type: 'value'
	    },
	    series: [
	        {
	            name:'MAX',
	            type:'line',
	            //step:'start',
	            data:max_key_num
	        },
	        {
	            name:'MAX_>10',
	            type:'line',
	            //step:'middle',
	            data:large_10_max
	        },
	        {
	            name:'MAX_>20',
	            type:'line',
	            //step:'end',
	            data:large_20_max
	        },
	    ]
	};
 
	element.setOption(option);

	})
}


$(document).ready(function() {
    updateBarChart(weibo_top10_chart,'#Hotkey# on rank count TOP10');
    updateLineChart(weibo_key_num_chart,'#Hotkey# index by DayofWeek');
});

//refresh each 1800s
var refresh=window.setInterval(function(){
    updateBarChart(weibo_top10,'#Hotkey# on rank count TOP10');
    updateLineChart(weibo_key_num_chart,'#Hotkey# index by DayofWeek');
},1800000);        

</script>
