use sakila;


SELECT title, special_features 
FROM film 
WHERE rating = 'PG-13';

SELECT DISTINCT `length` 
FROM film;

SELECT title, rental_rate, replacement_cost 
FROM film 
WHERE replacement_cost BETWEEN 20.00 AND 24.00;

SELECT f.title, c.name AS category, f.rating 
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE f.special_features LIKE '%Behind the Scenes%';

SELECT a.first_name, a.last_name 
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'ZOOLANDER FICTION';

SELECT a.address, ci.city, co.country 
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE s.store_id = 1;

SELECT f1.title AS title1, f2.title AS title2, f1.rating 
FROM film f1
JOIN film f2 ON f1.rating = f2.rating AND f1.film_id < f2.film_id;

SELECT f.title, s.store_id, stf.first_name AS manager_first_name, stf.last_name AS manager_last_name
FROM inventory i
JOIN film f ON i.film_id = f.film_id
JOIN store s ON i.store_id = s.store_id
JOIN staff stf ON s.manager_staff_id = stf.staff_id
WHERE s.store_id = 2;

-- clase 6 


SELECT first_name, last_name 
FROM actor 
WHERE last_name IN (
  SELECT last_name 
  FROM actor 
  GROUP BY last_name 
  HAVING COUNT(*) > 1
)
ORDER BY last_name, first_name;


SELECT a.first_name, a.last_name 
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;


SELECT c.customer_id, c.first_name, c.last_name 
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id
HAVING COUNT(DISTINCT r.inventory_id) = 1;


SELECT c.customer_id, c.first_name, c.last_name 
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id
HAVING COUNT(DISTINCT r.inventory_id) > 1;


SELECT DISTINCT a.first_name, a.last_name 
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title IN ('BETRAYED REAR', 'CATCH AMISTAD');


SELECT a.first_name, a.last_name 
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'BETRAYED REAR'
AND a.actor_id NOT IN (
  SELECT fa2.actor_id 
  FROM film_actor fa2 
  JOIN film f2 ON fa2.film_id = f2.film_id 
  WHERE f2.title = 'CATCH AMISTAD'
);


SELECT a.first_name, a.last_name 
FROM actor a
WHERE a.actor_id IN (
  SELECT fa1.actor_id 
  FROM film_actor fa1
  JOIN film f1 ON fa1.film_id = f1.film_id
  WHERE f1.title = 'BETRAYED REAR'
)
AND a.actor_id IN (
  SELECT fa2.actor_id 
  FROM film_actor fa2
  JOIN film f2 ON fa2.film_id = f2.film_id
  WHERE f2.title = 'CATCH AMISTAD'
);


SELECT a.first_name, a.last_name 
FROM actor a
WHERE a.actor_id NOT IN (
  SELECT fa.actor_id 
  FROM film_actor fa
  JOIN film f ON fa.film_id = f.film_id
  WHERE f.title IN ('BETRAYED REAR', 'CATCH AMISTAD')
);

