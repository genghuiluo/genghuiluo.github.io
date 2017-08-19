---
layout: post
title: informatica pmrep cheat sheet
date: 2017-08-19 13:08:04 +0800
categories: etl
---

my usage script [export_infa.sh](https://github.com/genghuiluo/CSCS-Team-DB/blob/master/export_infa.sh)

1. eg1：cd $INFA_HOME/server/bin 
    ``` shell
    pmrep connect -r RS_PMS_SIT -d Domain_PMSBISA1 -n Administrator -x Administrator 
    
    pmrep objectimport -i wf_ZKF_SIT_STAFFINFO.XML -c test.xml -l wf.log(用于导入指定文件) 
    ```
2. eg2：pmrep objectexport （用于导出指定文件） 
    ``` shell
    pmrep objectexport -n wf_name -o workflow -f folder_name -s -b -r -u exportfilename 
    #-s -b -r:这三个参数可以使导出的workflow中包含所有map的信息 
    ```
3. eg3：pmrep createconnection(用于在server上创建源或目标的数据库连接) 
    ```  shell
    pmrep createconnection -s Type -n Connectionname -u user -p password -c ConnectString -l CodePage 
    (Type=oracle ConnectionName=Source/Target_Connection CodePage=UTF-8 其余为数据库连接方式) 

    ```

> [pmrep cheat sheet @github](https://github.com/genghuiluo/legacy/blob/master/infa_cmd.cheatsheet)

