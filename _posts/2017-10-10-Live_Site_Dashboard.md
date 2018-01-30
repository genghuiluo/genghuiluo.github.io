---
layout: post
title: Live site dashboard 
date: 2018-01-30 21:58:46 +0800
categories: web
---


<div id="live_site_5" style="width: 100%; min-height: 800px"></div>
<div id="live_site_6" style="width: 100%; min-height: 600px"></div>

<script type="text/javascript">

var live_site_chart_5 = echarts.init(document.getElementById('live_site_5'));
var live_site_chart_6 = echarts.init(document.getElementById('live_site_6'));

function updateLineChart(month, element, title) {
	$.getJSON('http://feed.genghuiluo.cn/live/total_view_by_hour.json?month=' + month, function(data){

	var xdata = [];
	var ydata_zhanqi = []
	var ydata_huya = []
	var ydata_douyu = []
	var ydata_panda = []
	//var ydata_huomao = []
	
	$.each( data, function( key, val ) {

		switch (val.site) {
		case 'zhanqi':
			ydata_zhanqi.push(val.total_view);
			break;
		case 'huya':
			ydata_huya.push(val.total_view);
			break;
		case 'douyu':
			xdata.push(val.format_by_hour);
			ydata_douyu.push(val.total_view);
			break;
		case 'panda':
			ydata_panda.push(val.total_view);
			break;
		/*
		case 'huomao':
			ydata_huomao.push(val.total_view);
			break;
		*/
		}
        });
	
	option = {
    		title: {
    		    text: title,
		    x: 'center'
    		},
    		tooltip : {
    		    trigger: 'axis',
    		    axisPointer: {
    		        type: 'cross',
    		        label: {
    		            backgroundColor: '#6a7985'
    		        }
    		    }
    		},
    		legend: {
		    x: 'right',
    		    data:['战旗','虎牙','斗鱼','熊猫','火猫']
    		},
    		toolbox: {
		    x: 'left',
    		    feature: {
    		        saveAsImage: {}
    		    }
    		},
    		grid: {
    		    left: '3%',
    		    right: '4%',
    		    bottom: '3%',
    		    containLabel: true
    		},
    		xAxis : [
		    {
    		        //type : 'time',
    		        type : 'category',
    		        boundaryGap : false,
    		        data : xdata
    		    }
    		],
    		yAxis : [
    		    {
    		        type : 'value'
    		    }
    		],
    		series : [
    		    {
    		        name:'战旗',
    		        type:'line',
    		        stack: 'total_view_by_hour',
    		        areaStyle: {normal: {}},
    		        data: ydata_zhanqi
    		    },
    		    {
    		        name:'虎牙',
    		        type:'line',
    		        stack: 'total_view_by_hour',
    		        areaStyle: {normal: {}},
    		        data: ydata_huya
    		    },
    		    {
    		        name:'斗鱼',
    		        type:'line',
    		        stack: 'total_view_by_hour',
    		        areaStyle: {normal: {}},
    		        data: ydata_douyu
    		    },
    		    {
    		        name:'熊猫',
    		        type:'line',
    		        stack: '总量',
    		        areaStyle: {normal: {}},
    		        data: ydata_panda
    		    },
		/*
    		    {
    		        name:'火猫',
    		        type:'line',
    		        stack: 'total_view_by_hour',
    		        label: {
    		            normal: {
    		                show: true,
    		                position: 'top'
    		            }
    		        },
    		        areaStyle: {normal: {}},
    		        data: ydata_huomao
    		    }
		*/
    		]
	};
	
	element.setOption(option);
	})
}

function updatePieChart(month, element, title) {
	$.getJSON('http://feed.genghuiluo.cn/live/total_view_by_category.json', function(data){
	
	var xdata = [];
	// http://blog.csdn.net/zhouyanldh/article/details/6976280
	var ydatas = [];
	var ydata = {};
	
	$.each( data, function( key, val ) {
		xdata.push(val.site_category);
		ydata["value"] = val.total_view;
		ydata["name"] = val.site_category;
		ydatas.push(ydata);
		ydata = {}
	});

	//alert(ydata);
	//var jsonString = JSON.stringify(ydatas);

	option = {
	    title: {
    		text: title,
		x: 'center'
    	    },
	    tooltip: {
	        trigger: 'item',
	        formatter: "{a} <br/>{b}: {c} ({d}%)"
	    },
	    legend: {
	        orient: 'vertical',
	        x: 'right',
	        data: xdata
	    },
	    toolbox: {
		x: 'left',
    		feature: {
    		    saveAsImage: {}
    		}
    	    },
	    series: [
	        {
	            name:'合计访问(每小时人次):',
	            type:'pie',
	            radius: ['50%', '70%'],
	            avoidLabelOverlap: false,
	            label: {
	                normal: {
	                    show: false,
	                    position: 'center'
	                },
	                emphasis: {
	                    show: true,
	                    textStyle: {
	                        fontSize: '30',
	                        fontWeight: 'bold'
	                    }
	                }
	            },
	            labelLine: {
	                normal: {
	                    show: false
	                }
	            },
	            data: ydatas
	        }
	    ]
	};
	
	element.setOption(option);
	})
}



$(document).ready(function() {
    updateLineChart(5, live_site_chart_5,'May, 2017 - Total view by Hour');
    updatePieChart(123, live_site_chart_6,'Total view per hour by Catetory');
});


