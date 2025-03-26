create database if not exists imbd; 

use imbd; 

create table film ( 
	film_id int primary key auto_increment ,
    title varchar(255), 
    descripcion varchar(255),
    realese_year date
    );
    
create table actor (
    actor_id int primary key auto_increment,
    first_name varchar(100) not null,
    last_name varchar(100) not null
);

create table film_actor (
    actor_id int primary key,
    film_id int,
    foreign key (actor_id) references actor(actor_id),
    foreign key (film_id) references film(film_id) 
);

insert into actor (first_name, last_name) values ('Leonardo', 'DiCaprio'), ('Morgan', 'Freeman'), ('Scarlett', 'Johansson');

insert into film (title, descripcion, release_year) values ('Inception', 'A mind-bending thriller', 2010), ('The Shawshank Redemption', 'A story of hope and friendship', 1994), ('Lucy', 'A woman gains extraordinary abilities', 2014);

insert into film_actor (actor_id, film_id) values (1, 1), (2, 2), (3, 3), (1, 3);

