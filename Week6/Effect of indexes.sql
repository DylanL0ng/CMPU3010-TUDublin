select count(*) from m_movie;
select * from m_movie limit 1;
select distinct original_language from m_movie;
select distinct rstatus from m_movie;
select original_language, count(*) from m_movie group by original_language
order by count(*) desc;
explain analyze 
select original_language, count(*) from m_movie group by original_language
order by count(*) desc;
/*
This reveals the following:
QUERY PLAN                                                                                                         |
-------------------------------------------------------------------------------------------------------------------+
Sort  (cost=135.78..136.28 rows=200 width=20) (actual time=0.436..0.437 rows=28 loops=1)                           |
  Sort Key: (count(*)) DESC                                                                                        |
  Sort Method: quicksort  Memory: 26kB                                                                             |
  ->  HashAggregate  (cost=126.14..128.14 rows=200 width=20) (actual time=0.425..0.429 rows=28 loops=1)            |
        Group Key: original_language                                                                               |
        Batches: 1  Memory Usage: 40kB                                                                             |
        ->  Seq Scan on m_movie  (cost=0.00..123.76 rows=476 width=12) (actual time=0.055..0.238 rows=1112 loops=1)|
Planning Time: 0.055 ms                                                                                            |
Execution Time: 0.462 ms                                                                                           |
*/
--Let's index the table on original_language:
create index m_movie_orig_lang on m_movie(original_language);
-- Now run the explain plan again:
explain analyze 
select original_language, count(*) from m_movie group by original_language
order by count(*) desc;
/*
QUERY PLAN                                                                                                                                       |
-------------------------------------------------------------------------------------------------------------------------------------------------+
Sort  (cost=31.35..31.42 rows=28 width=11) (actual time=0.154..0.156 rows=28 loops=1)                                                            |
  Sort Key: (count(*)) DESC                                                                                                                      |
  Sort Method: quicksort  Memory: 26kB                                                                                                           |
  ->  GroupAggregate  (cost=0.15..30.67 rows=28 width=11) (actual time=0.020..0.143 rows=28 loops=1)                                             |
        Group Key: original_language                                                                                                             |
        ->  Index Only Scan using m_movie_orig_lang on m_movie  (cost=0.15..24.83 rows=1112 width=3) (actual time=0.015..0.065 rows=1112 loops=1)|
              Heap Fetches: 0                                                                                                                    |
Planning Time: 0.169 ms                                                                                                                          |
Execution Time: 0.172 ms                                                                                                                         |*/

--- Now let's look at an insert statement:

explain analyze Insert into M_MOVIE (BUDGET,GENRES,HOMEPAGE,MOVIE_ID,IMDB_ID,ORIGINAL_LANGUAGE,ORIGINAL_TITLE,POPULARITY,RELEASE_DATE,REVENUE,RUNTIME,RSTATUS,TAGLINE,TITLE,VIDEO,VOTE_AVERAGE,VOTE_COUNT) values 
(125000000,'[{''id'': 12, ''name'': ''Adventure''}, {''id'': 14, ''name'': ''Fantasy''}, {''id'': 10751, ''name'': ''Family''}]','http://harrypotter.warnerbros.com/harrypotterandthedeathlyhallows/mainsite/index.html',671,'tt0241527','en','Harry Potter and the Philosopher''s Stone',38.187238,'16/11/2001',976475550,152,'Released','Let the Magic Begin.','Harry Potter and the Deathly Hallows','FALSE',7.5,7188);
/*QUERY PLAN                                                                                   |
---------------------------------------------------------------------------------------------+
Insert on m_movie  (cost=0.00..0.01 rows=0 width=0) (actual time=0.054..0.054 rows=0 loops=1)|
  ->  Result  (cost=0.00..0.01 rows=1 width=1720) (actual time=0.002..0.002 rows=1 loops=1)  |
Planning Time: 0.040 ms                                                                      |
Execution Time: 0.066 ms                                                                     |*/

drop index m_movie_orig_lang;

explain analyze Insert into M_MOVIE (BUDGET,GENRES,HOMEPAGE,MOVIE_ID,IMDB_ID,ORIGINAL_LANGUAGE,ORIGINAL_TITLE,POPULARITY,RELEASE_DATE,REVENUE,RUNTIME,RSTATUS,TAGLINE,TITLE,VIDEO,VOTE_AVERAGE,VOTE_COUNT) values 
(125000000,'[{''id'': 12, ''name'': ''Adventure''}, {''id'': 14, ''name'': ''Fantasy''}, {''id'': 10751, ''name'': ''Family''}]','http://harrypotter.warnerbros.com/harrypotterandthedeathlyhallows/mainsite/index.html',671,'tt0241527','en','Harry Potter and the Philosopher''s Stone',38.187238,'16/11/2001',976475550,152,'Released','Let the Magic Begin.','Harry Potter and the Deathly Hallows','FALSE',7.5,7188);

/*                
QUERY PLAN                                                                                   |
---------------------------------------------------------------------------------------------+
Insert on m_movie  (cost=0.00..0.01 rows=0 width=0) (actual time=0.047..0.048 rows=0 loops=1)|
  ->  Result  (cost=0.00..0.01 rows=1 width=1720) (actual time=0.001..0.001 rows=1 loops=1)  |
Planning Time: 0.036 ms                                                                      |
Execution Time: 0.059 ms                                                                     |                                                                                                      |      
*/
