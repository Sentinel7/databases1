--Find all the games in England between the seasons 1920 and 1999 such that the total goals are at least 8. Order by the total goals descending.
SELECT *
FROM england
WHERE totgoal >= 8 AND Season >= 1920 AND Season <= 1999
ORDER BY totgoal DESC;


--Find the average total goals per season in England and France after the 1979 season. The results should be in (season, england_avg, france_avg) --triples, ordered by season.
SELECT T1.season,  england_avg, france_avg
FROM
	(SELECT england.season, AVG(england.totgoal) AS england_avg
	FROM england
	WHERE england.season >= 1980
	GROUP BY england.season) T1
		JOIN
	(SELECT france.season, AVG(france.totgoal) AS france_avg
	FROM france
	WHERE france.season >= 1980
	GROUP BY france.season) T2
ON T1.season=T2.season;


--Find the team in Germany that has won more visitor games than home games in total.
SELECT T1.home AS team
FROM
	(SELECT home, COUNT(*) AS h_cnt
	FROM germany
	WHERE hgoal > vgoal
	GROUP BY home) T1
	    JOIN
	(SELECT visitor, COUNT(*) AS v_cnt
	FROM germany
	WHERE vgoal > hgoal
	GROUP BY visitor) T2
	ON T1.home = T2.visitor
WHERE T1.h_cnt < T2.v_cnt;


--Find the teams that have had seasons with more visitor wins than home wins. Return the teams and the seasons, ordered by season descending.
SELECT T1.home AS team, T1.season
FROM
	(SELECT home, season, COUNT(*) AS h_cnt
	FROM germany
	WHERE hgoal > vgoal
	GROUP BY home,season) T1
	    JOIN
	(SELECT visitor, season, COUNT(*) AS v_cnt
	FROM germany
	WHERE vgoal > hgoal
	GROUP BY visitor,season) T2
		ON T1.home = T2.visitor AND T1.season=T2.season
WHERE T1.h_cnt < T2.v_cnt
ORDER BY t1.season DESC; 


--Find the number of seasons when each team has had more visitor wins than home wins. Return (team, num_seasons) doubles, ordered by the number of seasons descending.
SELECT T1.home AS team, COUNT(T1.season) AS num_seasons
FROM
	(SELECT home, season, COUNT(*) AS h_cnt
	FROM germany
	WHERE hgoal > vgoal
	GROUP BY home,season) T1
	    JOIN
	(SELECT visitor, season, COUNT(*) AS v_cnt
	FROM germany
	WHERE vgoal > hgoal
	GROUP BY visitor,season) T2
		ON T1.home = T2.visitor AND T1.season=T2.season
WHERE T1.h_cnt < T2.v_cnt
GROUP BY T1.season
ORDER BY num_seasons DESC;


--Find the number of games from France and England in tier 1 for each goal difference. 
--Return (goaldif, france_games, eng_games) triples, ordered by the goal difference.
SELECT f.goaldif, cntf AS france_games, cnte AS eng_games
FROM
	(SELECT goaldif, 1.0*COUNT(*)/(select count(*) from france where tier=1) AS cntf
	 FROM france
	 WHERE tier = 1
	 GROUP BY goaldif) f
	 	JOIN
	(SELECT goaldif, 1.0*COUNT(*)/(select count(*) from england where tier=1) AS cnte
	 FROM england
	 WHERE tier = 1
	 GROUP BY goaldif) e 
	 	ON f.goaldif=e.goaldif
ORDER BY f.goaldif;

--Find all the seasons when England had more total goals than France.
SELECT *
FROM (SELECT Season, AVG(totgoal) AS goals
	  FROM england
	  WHERE tier = 1
	  GROUP BY Season) e
         JOIN
	  (SELECT Season, AVG(totgoal) AS goals
	  FROM france
	  WHERE tier = 1
	  GROUP BY Season) f
	     ON e.season = f.season
WHERE f.goals > e.goals;


--Find the total home goals and visitor goals for each season in England and France from tier 1. Return (season, f_totalh, f_totalv, e_totalh, e_totalv)



