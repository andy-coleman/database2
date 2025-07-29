SELECT co.country_id, co.country, COUNT(ci.city_id) AS total_cities
FROM country co
JOIN city ci ON co.country_id = ci.country_id
GROUP BY co.country_id, co.country
ORDER BY co.country, co.country_id;

-- 2. Países con más de 10 ciudades, ordenados de mayor a menor
SELECT co.country, COUNT(ci.city_id) AS total_cities
FROM country co
JOIN city ci ON co.country_id = ci.country_id
GROUP BY co.country
HAVING COUNT(ci.city_id) > 10
ORDER BY total_cities DESC;

-- 3. Reporte de clientes: nombre, dirección, total de alquileres y dinero gastado
SELECT 
  c.first_name,
  c.last_name,
  a.address,
  COUNT(r.rental_id) AS total_rentals,
  SUM(p.amount) AS total_spent
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id, c.first_name, c.last_name, a.address
ORDER BY total_spent DESC;

-- 4. Categorías con mayor duración promedio de películas (orden descendente)
SELECT 
  c.name AS category,
  AVG(f.length) AS avg_duration
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY avg_duration DESC;

-- 5. Ventas por clasificación (rating) de película
SELECT 
  f.rating,
  SUM(p.amount) AS total_sales
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.rating
ORDER BY total_sales DESC;