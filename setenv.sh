startdate=`date -d "-15 day" +"%y%m%d0000"` 
enddate=`date -d "-1 day" +"%y%m%d0000"` 
today=`date -d "0 day" +"%y%m%d0000"`

INPUT=hbase://q_pages
OUTPUT=hdfs://mars/user/top10m$today



