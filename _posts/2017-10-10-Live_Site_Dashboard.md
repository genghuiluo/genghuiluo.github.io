---
layout: post
title: Live site dashboard 
date: 2018-01-06 22:03:12 +0800
categories: web
---


<div id="live_site_4" style="width: 100%; min-height: 600px"></div>
<div id="live_site_5" style="width: 100%; min-height: 600px"></div>
<div id="live_site_6" style="width: 100%; min-height: 600px"></div>
<div id="live_site_7" style="width: 100%; min-height: 600px"></div>

<script type="text/javascript">

var live_site_chart_4 = echarts.init(document.getElementById('live_site_4'));
var live_site_chart_6 = echarts.init(document.getElementById('live_site_5'));
var live_site_chart_5 = echarts.init(document.getElementById('live_site_6'));
var live_site_chart_7 = echarts.init(document.getElementById('live_site_7'));

function updateChart(month, element, title) {
	$.getJSON('http://feed.genghuiluo.cn/live/total_view_by_hour.json?month=' + month, function(data){

	var xdata = [];
	var ydata_zhanqi = []
	var ydata_huya = []
	var ydata_douyu = []
	var ydata_panda = []
	var ydata_huomao = []
	
	$.each( data, function( key, val ) {

		switch (val.site) {
		case 'zhanqi':
			xdata.push(val.by_hour);
			ydata_zhanqi.push(val.total_view);
			break;
		case 'huya':
			ydata_huya.push(val.total_view);
			break;
		case 'douyu':
			ydata_douyu.push(val.total_view);
			break;
		case 'panda':
			ydata_panda.push(val.total_view);
			break;
		case 'huomao':
			ydata_huomao.push(val.total_view);
			break;
		}
        });

	option = {
    		title: {
    		    text: title
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
    		    data:['战旗','虎牙','斗鱼','熊猫','火猫']
    		},
    		toolbox: {
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
    		]
	};

	element.setOption(option);
	})
}

$(document).ready(function() {
    updateChart(4, live_site_chart_4,'April,2017 - live site dashboard');
    updateChart(5, live_site_chart_5,'May,2017 - live site dashboard');
    updateChart(6, live_site_chart_6,'June,2017 - live site dashboard');
    updateChart(7, live_site_chart_7,'July,2017 - live site dashboard');
});


