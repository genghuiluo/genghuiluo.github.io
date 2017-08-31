---
layout: post
title: teradata-hadoop bridge intro
date: 2017-03-04 18:33:39 +0800
categories: database
---

> shared by ebay AIS ops

## What is the Bridge
The bridge is a framework for moving data in and out of Teradata.

Through SQL a user is able to import, export, stream data via the bridge.

A common use of the bridge is to move data between Teradata and Hadoop. The bridge is bi-directional. It is always instantiated via SQL.

## Bridge Architecture
The bridge is comprised of software and hardware.

The hardware portion is called the bridge cluster. The bridge cluster is a collection of nodes that have a high throughput network path to the Teradata database nodes (as well as the Hadoop data nodes).

![]({{ site.url }}/assets/teradata-hadoop_bridge_1.png)

![]({{ site.url }}/assets/teradata-hadoop_bridge_2.png)

There are a couple of software components. One software component is owned by Teradata and runs on the database node. This software is responsible for data transport between the AMP's and the bridge nodes. The second software component is owned by eBay and runs on the bridge cluster nodes. This software is responsible for data transport between the Teradata owned bridge process and the desired input or output medium (such as a local file or HDFS). The eBay software component is also
responsible for appropriately serializing and deserializing each row.

![]({{ site.url }}/assets/teradata-hadoop_bridge_3.png)

## Performance
Conservative To/from HDFS
- 2GB/s (gigabytes)

To/from local file system (on bridge nodes)
- 6.8GB/s

Example (12/17/13):
- Move UBI Event (noskew) data from Vivaldi in LVS data center to Apollo in PHX data center
- ~6.3B rows & 14TB (uncompressed)
- Hadoop format is compressed (lzop) text file (string format delimited by x01)
- From query submission to query complete (all data moved) 33 minutes 29 seconds (~7GB/s)

## Example
Suppose I want to export a table in my VDM to HDFS

| Screen Shot | Description |
| :---- | :---- |
| Command Line Tool: TD-Hadoop(develop by bridge team) | The tool generates the SQL([handwriting sample](https://github.com/genghuiluo/legacy/tree/master/teradata-hadoop-bridge)) I can execute to copy my VDM table to HDFS |
| ![]({{ site.url }}/assets/teradata-hadoop_bridge_4.png) | I paste the SQL into my Teradata client, execute it, and wait for it to finish |
| ![]({{ site.url }}/assets/teradata-hadoop_bridge_5.png) | I logon to Hadoop CLI node then view my table's data now available on HDFS |
