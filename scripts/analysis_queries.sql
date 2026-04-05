--Ən yaxşı oyunçular — reytinqə görə top 10
select *
from players p
where appearances >= 10
order by rating desc 
limit 10;

--liqaya gore ortalama reytinq ve qol
select
	league_x,
	ROUND(AVG(rating)::numeric, 2) as avg_rating,
	SUM(goals) as total_goals,
	ROUND(AVG(market_value)::numeric, 0) as avg_market_value
from
	players p 
group by league_x
order by avg_rating desc

--Overperformers
select 
	name,
	league_x,
	position,
	goals,
	ROUND(expected_goals::numeric, 1) AS xG,
    ROUND((goals - expected_goals)::numeric, 2) AS overperformance
from
	players p 
where
	position = 'F' and appearances >= 10
order by 
	overperformance  desc

--Underperformers
select 
	name,
	league_x,
	position,
	goals,
	ROUND(expected_goals::numeric, 1) AS xG,
    ROUND((goals - expected_goals)::numeric, 2) AS underperformance
from
	players p 
where
	position = 'F' and appearances >= 10
order by 
	underperformance  

--Ucuz amma yuksek reytinqli oyuncular
select
	name,
	league_x,
	position,
	rating,
	market_value,
	goals,
	assists
from
	players p 
where
	market_value < 1000000
	and rating > 7
	and appearances >= 15
order by 
	rating desc;
	
--En bahali oyuncular performanslari dogrudurmu qiymetlerine gore
select
	name,
	league_x,
	position,
	rating,
	market_value,
	goals,
	assists
from
	players p 
where
	market_value > 50000000
group by 
	league_x
order by 
	market_value desc;
	
--her movqede top oyuncular
select 
	name,
	league_x,
	position,
	rating,
	goals,
	assists
from(
	select *,
			row_number() over (partition by position order by rating desc) as rank
	from
		players
	where 
		appearances >= 10
) ranked
where rank <=5;

--en yaxsi forvetler - qol+assist
select
	name, 
	league_x,
	position,
	goals + assists as averaj,
	goals,
	assists,
	rating,
	market_value
from
	players p 
order by averaj desc;

--en cox kart goren oyuncular
select 
	name,
	league_x,
	position,
	yellow_cards,
	red_cards,
	yellow_cards + red_cards as all_cards
from
	players p 
order by 
	all_cards desc

--en yaxsi qapicilar
select
	name, 
	league_x,
	saves,
	rating,
	appearances,
    ROUND(saves::numeric / appearances, 1) AS saves_per_game
from
	players
WHERE 
	position = 'G' AND appearances >= 10 AND
	league_x in ('Premier League', 'LaLiga')
ORDER BY 
	saves DESC
LIMIT 10;

--Liqa uzre en bahali oyuncular
select 
	distinct on (league_x)
	league_x,
	name, 
	position,
	market_value,
	rating,
	goals
from
	players
order by 
	league_x,
	market_value desc

--Az pulla cox is goren ligalar
SELECT league_x,
       ROUND(AVG(market_value)::numeric / 1000000, 2) AS avg_value_M,
       ROUND(AVG(rating)::numeric, 2) AS avg_rating,
       ROUND(AVG(rating)::numeric / (AVG(market_value) / 1000000)::numeric, 4) AS value_efficiency
FROM players
GROUP BY league_x
ORDER BY value_efficiency DESC;
