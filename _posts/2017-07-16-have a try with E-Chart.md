---
layout: post
title: have a try with E-Chart
date: 2017-07-16 20:59:46 +0800
categories: web
---


<div id="main" style="width: 600px;height:400px;"></div>
<script type="text/javascript">
        // 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById('main'));
        
        var refresh=window.setInterval(function(){
            $.getJSON('http://dev.genghuiluo.cn:1235/weibo/realtimehot.json', function(data){
                        $.each( data, function( key, val ) {
                            alert(val.key_text)
                        });
            })
        },10000);

</script>
