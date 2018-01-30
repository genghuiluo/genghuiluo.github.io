---
layout: post
title: Weibo Hotkey Dashboard
date: 2018-01-30 22:25:01 +0800
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

function updateLineChart(element,title) {
$.getJSON('http://feed.genghuiluo.cn/weibo/key_num.json', function(data){


	var xdata = [];
	var max_data = [];
	var top10_data = [];
	var top20_data = [];
	var top50_data = [];

	$.each( data, function( key, val ) {
		xdata.push(val.dayofweek);	
		max_data.push(val.max_key_num);	
		top10_data.push(val.top10_avg);	
		top20_data.push(val.top20_avg);	
		top50_data.push(val.top50_avg);	
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
	        data: ['MAX','TOP10-AVG','TOP20-AVG','TOP50-AVG'],
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
	            step: 'start',
	            data:max_data
	        },
	        {
	            name:'TOP10-AVG',
	            type:'line',
	            step: 'middle',
	            data:top10_data
	        },
	        {
	            name:'TOP20-AVG',
	            type:'line',
	            step: 'end',
	            data:top20_data
	        },
		{
	            name:'TOP50-AVG',
	            type:'line',
	            step: 'end',
	            data:top50_data
	        }
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
