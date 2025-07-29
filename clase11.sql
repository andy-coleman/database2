-- 1. Find all the film titles that are NOT in the inventory
SELECT title
FROM film
WHERE film_id NOT IN (
  SELECT DISTINCT film_id FROM inventory
);

-- 2. Find all the films that are in the inventory but were never rented
-- Show title and inventory_id
SELECT f.title, i.inventory_id
FROM inventory i
JOIN film f ON i.film_id = f.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;

-- 3. Report: customer name, store_id, film title, rental and return dates
SELECT 
  c.first_name,
  c.last_name,
  c.store_id,
  f.title,
  r.rental_date,
  r.return_date
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
ORDER BY c.store_id, c.last_name;

-- 4. Show sales per store (money of rented films)
SELECT 
  s.store_id,
  SUM(p.amount) AS total_sales
FROM store s
JOIN staff st ON s.manager_staff_id = st.staff_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id;

-- 5. Show store's city, country, manager info and total sales (money)
-- Optional: use CONCAT to format city/country and manager's name
SELECT 
  s.store_id,
  CONCAT(ci.city, ', ', co.country) AS location,
  CONCAT(st.first_name, ' ', st.last_name) AS manager_name,
  SUM(p.amount) AS total_sales
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
JOIN staff st ON s.manager_staff_id = st.staff_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id, ci.city, co.country, st.first_name, st.last_name;

-- 6. Which actor has appeared in the most films?
SELECT 
  a.first_name,
  a.last_name,
  COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY film_count DESC
LIMIT 1;