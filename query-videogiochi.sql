--QUERY SELECT

--1- Selezionare tutte le software house americane (3)
select *
from software_houses
where country = 'United States'
--2- Selezionare tutti i giocatori della città di 'Rogahnland' (2)
select *
from players
where city = 'Rogahnland'
--3- Selezionare tutti i giocatori il cui nome finisce per "a" (220)
select *
from players
where name like '%a'
--4- Selezionare tutte le recensioni scritte dal giocatore con ID = 800 (11)
select *
from reviews
where player_id = 800

--5- Contare quanti tornei ci sono stati nell'anno 2015 (9)
select count(id) as numero_torneri
from tournaments
where year = 2015
--6- Selezionare tutti i premi che contengono nella descrizione la parola 'facere' (2)
select *
from awards
where description like '%facere%'
--7- Selezionare tutti i videogame che hanno la categoria 2 (FPS) o 6 (RPG), mostrandoli una sola volta (del videogioco vogliamo solo l'ID) (287)
select distinct videogame_id
from category_videogame
where category_id = 2 
OR category_id=6
--8- Selezionare tutte le recensioni con voto compreso tra 2 e 4 (2947)
select *
from reviews
where rating between 2 and 4
--9- Selezionare tutti i dati dei videogiochi rilasciati nell'anno 2020 (46)
select *
from videogames
where year(release_date) = 2020
--10- Selezionare gli id dei videogame che hanno ricevuto almeno una recensione da stelle, mostrandoli una sola volta (443)
select  distinct videogame_id
from reviews
where rating = 5

--*********** BONUS ***********

--11- Selezionare il numero e la media delle recensioni per il videogioco con ID = 412 (review number = 12, avg_rating = 3)
select count(videogame_id) as review_number, avg(rating) as avg_rating
from reviews
where videogame_id = 412

--12- Selezionare il numero di videogame che la software house con ID = 1 ha rilasciato nel 2018 (13
select *
from videogames
where software_house_id = 1 AND year(release_date) = 2018

--QUERY CON GROUPBY

--1- Contare quante software house ci sono per ogni paese (3)
select country, count(id) as companies_for_country
from software_houses
group by country
--2- Contare quante recensioni ha ricevuto ogni videogioco (del videogioco vogliamo solo l'ID) (500)
select videogame_id, count(id) as number_of_reviews_per_game
from reviews
group by videogame_id
--3- Contare quanti videogiochi hanno ciascuna classificazione PEGI (della classificazione PEGI vogliamo solo l'ID) (13)
select pegi_label_id, count(videogame_id) as number_of_games_per_pegi
from pegi_label_videogame
group by pegi_label_id
order by pegi_label_id asc
--4- Mostrare il numero di videogiochi rilasciati ogni anno (11)
select year(release_date), count(id) as number_of_games_per_year
from videogames
group by year(release_date)
--5- Contare quanti videogiochi sono disponbiili per ciascun device (del device vogliamo solo l'ID) (7)
select device_id, count(videogame_id) as number_of_games_per_device
from device_videogame
group by device_id
order by device_id asc
--6- Ordinare i videogame in base alla media delle recensioni (del videogioco vogliamo solo l'ID) (500)
select videogame_id as videogame_id, avg(rating) as average_rating
from reviews
group by videogame_id
order by avg(rating) asc
--QUERY CON JOIN

--1- Selezionare i dati di tutti giocatori che hanno scritto almeno una recensione, mostrandoli una sola volta (996)
select distinct players.id, players.name, players.lastname
from players
inner join reviews
on players.id = reviews.player_id

--2- Sezionare tutti i videogame dei tornei tenuti nel 2016, mostrandoli una sola volta (226)

select distinct videogames.id, videogames.name
from videogames
inner join tournament_videogame
on videogames.id = tournament_videogame.videogame_id
inner join tournaments
on tournaments.id =  tournament_videogame.tournament_id
where tournaments.year = 2016

--3- Mostrare le categorie di ogni videogioco (1718)
select distinct videogames.id, videogames.name, categories.name
from videogames
inner join category_videogame
on videogames.id = category_videogame.videogame_id
inner join categories
on categories.id = category_videogame.category_id
--4- Selezionare i dati di tutte le software house che hanno rilasciato almeno un gioco dopo il 2020, mostrandoli una sola volta (6)
select distinct software_houses.name as company_name
from software_houses
inner join videogames
on videogames.software_house_id = software_houses.id
where year(videogames.release_date) between 2020 and 2022
--5- Selezionare i premi ricevuti da ogni software house per i videogiochi che ha prodotto (55)
select  software_houses.name as company_name, awards.name as award_name
from software_houses
inner join videogames
on videogames.software_house_id = software_houses.id
inner join award_videogame
on award_videogame.videogame_id = videogames.id
inner join awards
on awards.id = award_videogame.award_id


--6- Selezionare categorie e classificazioni PEGI dei videogiochi che hanno ricevuto recensioni da 4 e 5 stelle, mostrandole una sola volta (3363)
select distinct categories.id as category_id, categories.name, pegi_labels.id, pegi_labels.name
from categories
inner join category_videogame
on category_videogame.category_id = categories.id
inner join pegi_label_videogame
on pegi_label_videogame.videogame_id = category_videogame.videogame_id
inner join pegi_labels
on pegi_labels.id = pegi_label_videogame.pegi_label_id
inner join reviews
on reviews.videogame_id = category_videogame.videogame_id
where reviews.rating between 4 and 5


--7- Selezionare quali giochi erano presenti nei tornei nei quali hanno partecipato i giocatori il cui nome inizia per 'S' (474)
select distinct  videogames.id, videogames.name
from videogames
inner join tournament_videogame
on tournament_videogame.videogame_id = videogames.id
inner join player_tournament
on player_tournament.tournament_id = tournament_videogame.tournament_id
inner join players
on players.id = player_tournament.player_id
where players.name like 'S%'
--8- Selezionare le città in cui è stato giocato il gioco dell'anno del 2018 (36)
select distinct tournaments.id, tournaments.name, tournaments.city
from tournaments
inner join tournament_videogame
on tournament_videogame.tournament_id = tournaments.id
inner join videogames
on videogames.id = tournament_videogame.videogame_id
inner join award_videogame
on award_videogame.videogame_id = videogames.id
inner join awards
on awards.id = award_videogame.award_id
where awards.name = 'Gioco dell''anno' and award_videogame.year = 2018



--9- Selezionare i giocatori che hanno giocato al gioco più atteso del 2018 in un torneo del 2019 (3306)
select  players.id, players.name as player_name, players.lastname as player_last_name
from players
inner join player_tournament
on player_tournament.player_id = players.id
inner join tournaments
on tournaments.id = player_tournament.tournament_id
inner join tournament_videogame
on tournament_videogame.tournament_id = tournaments.id
inner join award_videogame
on award_videogame.videogame_id = tournament_videogame.videogame_id
inner join awards
on awards.id = award_videogame.award_id
where tournaments.year = 2019 and award_videogame.year = 2018 and awards.name = 'Gioco più atteso'

--*********** BONUS ***********

--10- Selezionare i dati della prima software house che ha rilasciato un gioco, assieme ai dati del gioco stesso (software house id : 5)

--11- Selezionare i dati del videogame (id, name, release_date, totale recensioni) con più recensioni (videogame id : 398)

--12- Selezionare la software house che ha vinto più premi tra il 2015 e il 2016 (software house id : 1)

--13- Selezionare le categorie dei videogame i quali hanno una media recensioni inferiore a 1.5 (10)