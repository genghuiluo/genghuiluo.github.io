---
layout: post
title: informatica cmd cheat sheet
date: 2017-05-22 19:00:19 +0800
categories: ETL
---

eg1：cd $INFA_HOME/server/bin 

pmrep connect -r RS_PMS_SIT -d Domain_PMSBISA1 -n Administrator -x Administrator 

pmrep objectimport -i wf_ZKF_SIT_STAFFINFO.XML -c test.xml -l wf.log(用于导入指定文件) 

eg2：pmrep objectexport （用于导出指定文件） 

pmrep objectexport -n wf_name -o workflow -f folder_name -s -b -r -u exportfilename 
-s -b -r:这三个参数可以使导出的workflow中包含所有map的信息 

eg3：pmrep createconnection(用于在server上创建源或目标的数据库连接) 

pmrep createconnection -s Type -n Connectionname -u user -p password -c ConnectString -l CodePage 

(Type=oracle ConnectionName=Source/Target_Connection CodePage=UTF-8 其余为数据库连接方式) 
  
[cheat sheet @github](https://github.com/genghuiluo/legacy/blob/master/infa_cmd.cheatsheet)
