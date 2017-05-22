---
layout: post
title: informatcia Active and Passive Rule
date: 2017-05-22 19:01:47 +0800
categories: ETL
---

Types of Transformations: 
  
1. Active Transformation 
2. Passive Transformation 
3. Active/Passive Transformation 
4. Connected/Unconnected Transformation 
5. Multigroup Transformation 
6. Blocking Transformation 
  
1. Active Transformation:- An active transformation can perform any of the following actions: 
  
- (a) Change the number of rows that pass through the transformation:- for eg, the Filter transformation is 
active because it removes rows that do not meet the filter condition. 
- (b) Change the transaction boundary:- for eg, , the Transaction Control transformation is active because it defines a commit or roll back transaction based on an expression evaluated for each row. 
- (c) Change the row type:- for eg, the Update Strategy transformation is active because it flags rows for 
insert, delete, update, or reject. 
  
  
2. Passive Transformation:- An Passive transformation which will satisfy all below conditions: 
  
- (a) Do not Change the number of rows that pass through the transformation 
- (b) Maintains the transaction boundary 
- (c) Maintains the row type. 
  
Important Note:- The Designer does not allow you to connect multiple active transformations or an active and a passive transformation to the same downstream transformation or transformation input group because the Integration Service may not be able to concatenate the rows passed by active transformations. For example, one branch in amapping contains an Update Strategy transformation that flags a row for delete. Another branch contains an Update Strategy transformation that flags a row for insert. If you connect these transformations to a single transformation input group, the Integration Service cannot combine the delete and insert operations for the row. 
  
3. Connected Transformations:- Transformations which are connected to other transformation in the data flow are called Connected Transformations 
  
4. Unconnected Transformations:- Transformations which are not connected to other transformation in the data flow are called Connected Transformations.An unconnected transformation is called within another 
transformation, and returns a value to that transformation. 
  
List of Informatica Transformation Category Wise 
![]({{ site.url }}/assets/active_and_passive_rule.jpg)

Connected and Unconnected Transformation (Both) Connected Transformation 
1. External Procedure Rest All transformations are connected. 
2. Stored Procedure 
3. Lookup  
  
MultiGroup Transformations 
1. Union 
2. Router 
3. Joiner 
4. Custom 
5. Unstructured Data 
6. XML Source Qualifier 
7. XML Generator 
8. XML Parser 
9. XML Target Definition 
  
Blocking Transformations  
1. Custom transformation with Input may block property enabled. 
2. Joiner transformation configured for unsorted Input. 
  
