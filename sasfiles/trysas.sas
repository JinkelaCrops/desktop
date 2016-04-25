/* 逻辑库的设置 */
libname Learnsas "d:\SAS_script";
/*-------------------------------------data步-----------------------------------------------------*/
/* 数据的导入 */
data Learnsas.Customer_trysas12;
input Cust_ID Order_ID Order_DT $ Txn_Amt @@;
cards;
1001    2016010110      20160106        100
1001    2016020302      20160203        30.3
1002    2016010102      20160101        20
1003    2016020301      20160203        30
1003    2016020303      20160203        45
1004    2016030702      20160308        22.6
1005    2016030801      20160309        10.1
1006    2016030807      20160309        33
1007    2016030810      20160309        33.5
1008    2016030811      20160309        40
1010    2016030812      20160309        80
1011    2016030901      20160310        100
;
run;
/*-------------------------------------proc步-----------------------------------------------------*/
/* var */
proc print data=Learnsas.Customer_trysas12;
var cust_id order_id order_dt; 
run;
proc sql;
    select * from Learnsas.Customer_trysas12
    where Txn_Amt>=20;
quit;