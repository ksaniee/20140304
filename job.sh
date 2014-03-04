pig -param startdate=`date -d "-15 day" +"%y%m%d0000"` -param enddate=`date -d "-1 day" +"%y%m%d0000"` -param today=`date -d "0 day" +"%y%m%d0000"` crawl10mlist.pig
