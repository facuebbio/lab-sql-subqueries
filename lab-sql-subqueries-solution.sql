use sakila;

## 1. How many copies of the film Hunchback Impossible exist in the inventory system?
select * from inventory;
select * from film; 

select count(inventory_id) as copies_film
from inventory
where film_id = (
    select film_id from film where title = 'Hunchback Impossible'
);

## 2. List all films whose length is longer than the average of all the films.
select title, length 
from film
where length > (
	select avg(length)
	from film
);

## 3. Use subqueries to display all actors who appear in the film Alone Trip.
select * from actor; ## a.actor_id, a.first_name, a.last_name
select * from film_actor; ## fa.actor_id, fa.film_id
select * from film; ## f.film_id, f.title

## first subquery
select a.actor_id, a.first_name, a.last_name, f.title
from actor a
join film_actor fa on a.actor_id = fa.actor_id
join film f on fa.film_id = f.film_id;

## final subquery
select actor_id, first_name, last_name, title
from (
	select a.actor_id, a.first_name, a.last_name, f.title
	from actor a
	join film_actor fa on a.actor_id = fa.actor_id
	join film f on fa.film_id = f.film_id
) sub1
where title = "Alone Trip";

## 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
## Identify all movies categorized as family films.
select * from film;

select film_id, title, rating
from film;

select title
from (
	select film_id, title, rating
	from film
) sub1
where rating = "G";

## 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
## Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
## that will help you get the relevant information.

select * from customer; ## c.address_id, c.first_name, c.email
select * from address; ## a.address_id, a.city_id
select * from city; ## ci.city_id, ci.country_id
select * from country; ## co.country_id, co.country
## first subquery
select c.first_name, c.email, co.country
from customer c
join address a on c.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id;

## final query
select first_name, email, country
from (select c.first_name, c.email, co.country
		from customer c
		join address a on c.address_id = a.address_id
		join city ci on a.city_id = ci.city_id
		join country co on ci.country_id = co.country_id)sub1
where country = "Canada";

## 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films.
##  First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select * from film;
select * from film_actor;
select * from actor;

select f.title, a.first_name, a.last_name
from film f
join film_actor fa on f.film_id = fa.film_id
join actor a on fa.actor_id = a.actor_id
where a.actor_id = (
    select actor_id
    from (
        select actor_id, count(*) as film_count
        from film_actor
        group by actor_id
        order by film_count desc
        limit 1
    ) as most_prolific_actor
)
limit 10;

## 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer 
## ie the customer that has made the largest sum of payments

select c.customer_id, c.first_name, c.last_name, sum(p.amount) as total_payments
from customer c
join payment p on c.customer_id = p.customer_id
group by c.customer_id, c.first_name, c.last_name
order by total_payments desc
limit 1;

