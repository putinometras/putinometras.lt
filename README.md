putinometras.lt
===============

putinometras.lt - Lietuvos interneto žiniasklados antraščių putinometras

2014-11-11 - 2015-09-04 veikęs interneto žiniasklados antraščių monitoringo ir analizės projektas.

Duomenys (220961 antraštė iš 5 populiariausių žinių portalų pagal http://www.audience.lt):
* [headlines.db](headlines.db) - SQLite db
* [headlines.csv](headlines.csv) - CSV

Metodika:
* [rss2db.pl](rss2db.pl)  - duomenų surinkimas per RSS
* [graph.sh](graph.sh) - grafikų generavimas
* [genpage.sh](genpage.sh) - tinklapio generavimas
* [crontab](crontab) - cron job

Tinklapis:
* index.html
* main.css
* p.png
* g.png
* g1.png
* g2.png

## Rezultatai
 
### Putinas:
![Putinas](g.png "Putinas")

### Kontrolinė grupė:
![Kontrolinė grupė](g1.png "Kontrolinė grupė")

Viso | Putinas | % | Obama |  % | Grybauskaitė | %
------------- | ------------- | ------------- | ------------- | ------------- | ------------- | -------------
220961  | 3010 | 1 | 726 | 0 | 1153 | 1

### Rusija:
![Rusija](g2.png "Rusija")
