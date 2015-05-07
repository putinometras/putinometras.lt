#!/bin/bash

BD="/www/putinometras.lt/data"
DB="${BD}/headlines.db"
SQLite="/usr/bin/sqlite3"
SP="-header -html"

# function to assign heredoc block to variable
define(){ IFS='\n' read -r -d '' ${1} || true; }
# usage:
# define VAR <<'EOF'
#   heredoc
#   block
# EOF

define HEAD <<'EOF'
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="lt">
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <link rel="stylesheet" href="/main.css" type="text/css" media="all" />
  </head>
  <body>
EOF

define FOOT <<'EOF'
  </body>
</html>
EOF

echo "$HEAD"

cat << EOF
<div class="title2">Lietuvos interneto žiniasklados antraščių</div>
<div class="title1">putinometras</div>
<div class="title2">Lygis (%):</div>
<img class="center" src="p.png">
<div class="title2">Putinas:</div>
<img class="center" src="g.png">
<table border=1 class="center">
EOF

echo "select date as Data,
             count(date) as Viso,
             sum(case when headline like '%putin%' then 1 else 0 end) as Putinas,
             cast(round(sum(case when headline like '%putin%' then 100.0 else 0 end) / count(date)) as integer) as '%'
      from headlines
             group by date
             order by date desc
             limit 30;" | ${SQLite} ${SP} ${DB}

cat << EOF
</table>
<div class="title2">Kontrolinė grupė:</div>
<img class="center" src="g1.png">
<table border=1 class="center">
EOF

echo "select date as Data,
             count(date) as Viso,
             sum(case when headline like '%putin%' then 1 else 0 end) as Putinas,
             cast(round(sum(case when headline like '%putin%' then 100.0 else 0 end) / count(date)) as integer) as '%',
             sum(case when headline like '%obam%' then 1 else 0 end) as Obama,
             cast(round(sum(case when headline like '%obam%' then 100.0 else 0 end) / count(date)) as integer) as '%',
             sum(case when headline like '%grybauskait%' then 1 else 0 end) as Grybauskaitė,
             cast(round(sum(case when headline like '%grybauskait%' then 100.0 else 0 end) / count(date)) as integer) as '%'
      from headlines
             group by date
             order by date desc
             limit 30;" | ${SQLite} ${SP} ${DB}

             
cat << EOF
</table>
<div class="title2">Visų laikų:</div>
<table border=1 class="center">
EOF

echo "select count (date) as Viso,
             sum(case when headline like '%putin%' then 1 else 0 end) as 'Putinas',
             cast(round(sum(case when headline like '%putin%' then 100.0 else 0 end) /  count(date)) as integer) as '%',
             sum(case when headline like '%obam%' then 1 else 0 end) as 'Obama',
             cast(round(sum(case when headline like '%obam%' then 100.0 else 0 end) /  count(date)) as integer) as '%',
             sum(case when headline like '%grybauskait%' then 1 else 0 end) as 'Grybauskaitė',
             cast(round(sum(case when headline like '%grybauskait%' then 100.0 else 0 end) /  count(date)) as integer) as '%'
      from headlines;"  | ${SQLite} ${SP} ${DB}

cat << EOF
</table>
<div class="title2">Rusija:</div>
<img class="center" src="g2.png">
<table border=1 class="center">
EOF

echo "select date as Data,
             count(date) as Viso,
             sum(case when headline like '%rusij%' then 1 else 0 end) as Rusija,
             cast(round(sum(case when headline like '%rusij%' then 100.0 else 0 end) / count(date)) as integer) as '%'
      from headlines
             group by date
             order by date desc
             limit 30;" | ${SQLite} ${SP} ${DB}

cat << EOF
</table>
<div class="title2">Betteridge'o <a href="http://en.wikipedia.org/wiki/Betteridge%27s_law_of_headlines">dėsnis</a>:</div>
<table border=1 class="center">
EOF

echo "select count (date) as Viso,
             sum(case when headline like '%?%' then 1 else 0 end) as '???',
             cast(round(sum(case when headline like '%?%' then 100.0 else 0 end) /  count(date)) as integer) as '%'
      from headlines;"  | ${SQLite} ${SP} ${DB}

cat << EOF  
</table>
<div class="title2"></div>

<div class="text1">atnaujinta:
EOF

echo "select * from system;" | ${SQLite} ${DB}
cat << EOF
</div>
<div class="text1">kontaktai: info @ putinometras.lt</div>
<div class="text1">metodika: <a href="https://github.com/putinometras/putinometras.lt">github</a></div>
<div class="text1">duomenys: <a href="headlines.db">sqlite</a>, <a href="headlines.csv">csv</a></div>
EOF
echo "$FOOT"


