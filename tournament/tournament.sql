-- Table definitions for the tournament project.
-- by michael rosata

<<<<<<< HEAD
drop database if exists tournament;
create database tournament;
\c tournament;

drop table if exists
    tournaments, players, matches;

-- Reviewer said to calculate tournament id of open tournament in code by
-- calculating matches rather than listing whether the tournament is open or
-- not. I think if in the future there were thousands of tournaments it would
-- be easier to search for a column that indicates a tournament is opened or
-- closed rather than calculate # of players and matches in each tournament then
-- compare to calculation of total matches in the tournament. I am taking advice
-- of reviewer but I wonder if in a case like this it is better to not have to
-- do calculations to figure out which tournaments are closed. Maybe compromise
-- would be to not allow 2 tournaments to run at the same time and only grab
create table tournaments (
  tournament_id serial primary key,
  opened timestamp null default current_timestamp
);

create table players (
  player_id serial primary key,
  player_name varchar(30),
  tournament_id int references tournaments (tournament_id)
);

-- My code review said not to put 'loser' in table because the winner can be
-- calculated by the playerStandings function. However, recording the loser
-- in a tournament database is a function of history/recording. In competitions
-- it is always an interest to know who a winner won their matches against.
create table matches (
  match_id serial primary key,
  tournament_id integer,
  loser integer references players (player_id),
  winner integer references players (player_id) null
);
=======
drop view if exists rankings;

drop table if exists
    players, tournaments, matches;


create table tournaments (
    id serial primary key,
    status varchar(6) default 'open' not null,
    round integer default 1 not null,
    winner varchar(10) null
);

create table players (
    id serial primary key,
    name varchar(30),
    tid int references tournaments (id)
);


create table matches (
    tid integer,
    rid integer,
    loser integer references players (id),
    winner integer references players (id) null,
    primary key (tid, rid, winner)
);
-- pair players with opponent who has won ~ same # of matches

-- a view that lists players in the order of their ranking
-- create or replace view rankings (id, name, ranking) as 
--    select id, name, round(
--        (select count(*) from matches where winner = id) /
--        (select count(*) from matches where winner = id or loser = id)
--    , 2) as ranking
--from players order by ranking desc;

-- a view that lists players in the order of their ranking
create or replace view rankings (id, name, ranking) as 
    select id, name, (
        (select count(*) from matches where winner = players.id))
    as ranking
from players group by players.id order by ranking desc;

-- todo: create trigger rankings_update before insert on matches execute procedure sort_rankings

>>>>>>> bc8bf1c66abe876160d532e451023d31befbfbbf
