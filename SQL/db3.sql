===========================================================================================

done 1) Пары корпораций, владеющих одинаковыми командами разработчиков

SELECT DISTINCT CORP1.corp_id AS corp1, CORP2.corp_id AS corp2, TEAM.team_id AS team_id, TEAM.team_name AS team_name ;
FROM corporation AS CORP1, corporation AS CORP2, corp_team AS CP1, corp_team AS CP2, programmers_team AS TEAM ;
WHERE(((CP1.team_id = CP2.team_id ;
AND CP1.team_id = TEAM.team_id) ;
AND CP1.corp_id = CORP1.corp_id) ;
AND CP2.corp_id = CORP2.corp_id) ;
AND CORP1.corp_name <> CORP2.corp_name ;
ORDER BY team_name


done 2) В каких многоплатфомернных ( > 3 ) играх нет мультиплеера, допустимый возраст игрока выше 12 лет(вкл)?

SELECT DISTINCT videogames.vg_id, videogames.vg_name,  videogames.multiplayer_game, videogames.age_restrictions, COUNT(vg_platf.series_id) AS numOfMult ;
FROM vg_platf ;
JOIN vg_series ON vg_series.series_id = vg_platf.series_id ;
JOIN videogames ON vg_platf.series_id = videogames.series_id ;
WHERE ( videogames.age_restrictions >= 12 ;
AND videogames.multiplayer_game = .F.) ;
GROUP BY videogames.vg_id, videogames.vg_name, vg_platf.series_id, videogames.multiplayer_game, videogames.age_restrictions ;
ORDER BY videogames.vg_id ;
HAVING COUNT(vg_platf.series_id) > 3 

done 3) Корпорация с наибольшим разнообразием жанров видеоигр

SELECT vg_genres.series_id, vg_series.series_name, corp_series_vg.corp_id, corp_series_vg.corp_name, COUNT(vg_genres.series_id) AS cnt_series_id ;
FROM vg_genres ;
JOIN vg_series ON vg_genres.series_id = vg_series.series_id ;
JOIN corp_series_vg ON vg_genres.series_id = corp_series_vg.series_id ;
WHERE vg_genres.series_id = ;
(SELECT MAX(vg_genres.series_id) ;
FROM vg_genres genr WHERE vg_genres.series_id = genr.series_id) ;
GROUP BY vg_genres.series_id, vg_series.series_name, corp_series_vg.corp_id, corp_series_vg.corp_name ;
ORDER BY cnt_series_id 

done 4) Определить игры и их жанры, имеющие минимальную популярность
SELECT DISTINCT videogames.vg_id, videogames.vg_name, vg_genres.genre_name, videogames.popularity ;
FROM videogames ;
JOIN vg_series ON videogames.series_id = vg_series.series_id ;
JOIN vg_genres ON vg_series.series_id = vg_genres.series_id ;
WHERE videogames.popularity = (SELECT MIN(videogames.popularity) FROM videogames vd WHERE videogames.series_id = vd.series_id) ;
ORDER BY videogames.vg_id 


done 5) Определить страны команд, которые были основаны в определенный промежуток времени 
и количество сотрудников больше среднего значения

SELECT DISTINCT programmers_team.team_id, programmers_team.team_name, programmers_team.foundation, programmers_team.employees, vg_country.country_id, countries.name ;
FROM programmers_team ;
JOIN countries ON vg_country.country_id = countries.country_id ;
JOIN vg_country ON programmers_team.team_id = vg_country.team_id ;
WHERE (programmers_team.foundation > 1985 ;
AND programmers_team.foundation < 1995) ;
AND programmers_team.employees > (SELECT AVG(programmers_team.employees) FROM programmers_team) ; 
ORDER BY programmers_team.team_id


done 6) Определить игру, не получившую награды за определенный промежуток времени, но с популярностью выше среднего

SELECT DISTINCT videogames.vg_id, videogames.vg_name, videogames.popularity ;
FROM videogames, vg_awards ;
WHERE videogames.vg_id NOT IN (SELECT DISTINCT vg_awards.vg_id FROM vg_awards ;
WHERE vg_awards.year > 2000 ;
AND vg_awards.year < 2010) ;
AND videogames.popularity > (SELECT AVG(videogames.popularity) FROM videogames) ;
ORDER BY videogames.vg_id


done 7) Корпорация с максимальным заработком из заданной страны

SELECT DISTINCT corporation.corp_id, corporation.corp_name, corporation.net_profit, vg_country.country_id ;
FROM corporation ;
JOIN (SELECT DISTINCT corp_id FROM vg_country WHERE vg_country.country_id = 3 GROUP BY corp_id) as t ;
ON (t.corp_id = corporation.corp_id) WHERE corporation.net_profit = (SELECT MAX(corporation.net_profit) FROM corporation) ;
ORDER BY corporation.corp_id