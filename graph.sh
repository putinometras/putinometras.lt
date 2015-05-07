#!/bin/bash

BD="/www/putinometras.lt/data"
DB="${BD}/headlines.db"
SQLite="/usr/bin/sqlite3"
GP="/usr/bin/gnuplot"

# current level graph
## from stdin
echo "select date as Data,
             cast(round(sum(case when headline like '%putin%' then 100.0 else 0 end) / count(date)) as integer) as '%'
      from headlines
      group by date
      order by date desc
      limit 1;" | \
 ${SQLite}  -separator ' ' ${DB}  | \
 ${GP} -p -e "set terminal png size 180,256;
              set output '${BD}/p.png';
              set style data histogram;
              set style fill solid border -1;
              set boxwidth 99 absolute;  set yrange [0:100];
              plot \"-\" using 2:xtic(1) notitle"

# time graph
## generate datasource
echo "select date as Data,
             sum(case when headline like '%putin%' then 1 else 0 end) as Putin,
             cast(round(sum(case when headline like '%putin%' then 100.0 else 0 end) / count(date)) as integer) as '%'
      from headlines
      group by date
      order by date desc;" | ${SQLite} -separator ',' ${DB} > ${BD}/ds.txt
## plot
${GP} -p -e "set terminal png;
             set output '${BD}/g.png';
             set datafile separator ',';
             set timefmt '%Y-%m-%d';
             set xdata time;
             set format x '%F';
             set xtics rotate by 45 right;
             plot '${BD}/ds.txt' using 1:3 t '%' w filledcurves,
                  '${BD}/ds.txt' using 1:2 t 'abs' w lines"

# control group graph
## generate datasource
echo "select date as Data,
             sum(case when headline like '%putin%' then 1 else 0 end) as Putin,
             sum(case when headline like '%obam%' then 1 else 0 end) as Obama,
             sum(case when headline like '%grybauskait%' then 1 else 0 end) as Grybauskaite
      from headlines
      group by date
      order by date desc;" | ${SQLite} -separator ',' ${DB} > ${BD}/ds1.txt
## plot
${GP} -p -e "set terminal png;
             set output '${BD}/g1.png';
             set style fill transparent pattern 4 bo;
             set datafile separator ',';
             set timefmt '%Y-%m-%d';
             set xdata time;
             set format x '%F';
             set xtics rotate by 45 right;
             plot '${BD}/ds1.txt' using 1:2 t 'Putin' w filledcurves x1,
                  '${BD}/ds1.txt' using 1:3 t 'Obama' w filledcurves x1,
                  '${BD}/ds1.txt' using 1:4 t 'Grybauskaite' w filledcurves x1;"

# Country graph
## generate datasource
echo "select date as Data,
             sum(case when headline like '%rusij%' then 1 else 0 end) as Rusija,
             cast(round(sum(case when headline like '%rusij%' then 100.0 else 0 end) / count(date)) as integer) as '%'
      from headlines
      group by date
      order by date desc;" | ${SQLite} -separator ',' ${DB} > ${BD}/ds2.txt
## plot
${GP} -p -e "set terminal png;
             set output '${BD}/g2.png';
             set datafile separator ',';
             set timefmt '%Y-%m-%d';
             set xdata time;
             set format x '%F';
             set xtics rotate by 45 right;
             plot '${BD}/ds2.txt' using 1:2 t 'Rusija' w filledcurves x1 lc rgb 'blue',
                  '${BD}/ds2.txt' using 1:3 t '%' w filledcurves x1 lc rgb 'red';"

# export data to csv
# not exactly graphing part, but it fits here
echo "select * from headlines order by date,time;" | ${SQLite} -header -csv ${DB} > ${BD}/headlines.csv
