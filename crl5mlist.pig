REGISTER '/home/kamron/adsafe-pigudfs.jar';
DEFINE REVERSE_URL com.adsafe.pigudfs.urls.REVERSE_URL();
SET default_parallel 250;
S = LOAD 'hbase://q_pages' USING com.adsafe.maged.common.hbase.HBaseStorage('t:d', '-loa$
Surl = foreach S generate key.url as url, key.date as date;
Socc = foreach (group Surl by url) {
        dates = Surl.date;
        unique_dates = DISTINCT dates;
        generate CONCAT(group,'') as url2:chararray, COUNT(unique_dates) as occ, COUNT(S$
};

EXEC;
Sf = FILTER Socc by (cnt > 20);
M = foreach (group Sf all) GENERATE MAX(Sf.cnt);
Sexp = foreach Sf generate $0, (1+ ($1 / (float)M.$0)) * (1 + ($2 / 7)) ;
Ssrt = ORDER Sexp by $1 desc;
S10m = limit Ssrt 10000000;

Ssp = LOAD 'hbase://q_pages' USING
com.adsafe.maged.common.hbase.HBaseStorage('s:p', '-loadKey');
Sv = foreach Ssp generate key.url, p.Scores;
B = FOREACH Sv GENERATE $0, REGEX_EXTRACT($1,
'visibility=([0-9]*)',1) as vis;
Bf = FILTER B by (int)$1 == 1000;

joined = join Bf by $0, S10m by $0;
joinedf = filter joined by ((int)Bf::vis == 1000);
S10mF = foreach joinedf generate $0, $3;
S10mF2 = filter S10mF by NOT ($0 matches '.*/ad/.*' OR $0 matches '.*/ads/.*' OR $0 matc$
$0 matches '.*/ad-.*' OR $0 matches '.*/ads..*' OR $0 matches '.*/ad..*' OR $0 matches '$
$0 matches '.*adserving.*' OR $0 matches '.*160x600.*' OR $0 matches '.*728x90.*' OR $0 $
'.*300x250.*' OR $0 matches '.*468x60.*' OR $0 matches '.*120X240.*' OR $0 matches '.*18$
matches '.*120x600.*' OR $0 matches '.*336x280.*' OR $0 matches '.*425x600.*' OR $0 matc$
OR $0 matches '.*300X600.*' OR $0 matches '.*/dfp?.*');
S10mF3 = ORDER S10mF2 by $1 desc;
s5m = limit S10mF3 5000000;
s5mR = foreach s5m generate REVERSE_URL($0);
store s5mR into 'top10m$today';
