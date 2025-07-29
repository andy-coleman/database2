-- 1. Crear vista list_of_customers
CREATE OR REPLACE VIEW list_of_customers AS
SELECT 
  c.customer_id,
  CONCAT(c.first_name, ' ', c.last_name) AS full_name,
  a.address,
  a.postal_code AS zip_code,
  a.phone,
  ci.city,
  co.country,
  CASE 
    WHEN c.active = 1 THEN 'active'
    ELSE 'inactive'
  END AS status,
  c.store_id
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;

-- 2. Crear vista film_details
CREATE OR REPLACE VIEW film_details AS
SELECT 
  f.film_id,
  f.title,
  f.description,
  c.name AS category,
  f.rental_rate AS price,
  f.length,
  f.rating,
  GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name) SEPARATOR ', ') AS actors
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY f.film_id, f.title, f.description, c.name, f.rental_rate, f.length, f.rating;

-- 3. Crear vista sales_by_film_category
CREATE OR REPLACE VIEW sales_by_film_category AS
SELECT 
  c.name AS category,
  COUNT(p.payment_id) AS total_rental
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

-- 4. Crear vista actor_information
CREATE OR REPLACE VIEW actor_information AS
SELECT 
  a.actor_id,
  a.first_name,
  a.last_name,
  COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- 5. Análisis de la vista actor_info
-- actor_info ya existe en Sakila y su consulta es:

/*
CREATE VIEW actor_info AS
SELECT
  a.actor_id,
  a.first_name,
  a.last_name,
  GROUP_CONCAT(DISTINCT
    CONCAT(c.name, ': ',
      (SELECT GROUP_CONCAT(f.title ORDER BY f.title SEPARATOR ', ')
       FROM film f
       INNER JOIN film_category fc ON f.film_id = fc.film_id
       INNER JOIN film_actor fa2 ON f.film_id = fa2.film_id
       WHERE fc.category_id = c.category_id AND fa2.actor_id = a.actor_id)
    ) SEPARATOR '; ') AS film_info
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN film_category fc ON fa.film_id = fc.film_id
LEFT JOIN category c ON fc.category_id = c.category_id
GROUP BY a.actor_id, a.first_name, a.last_name;
*/

-- EXPLICACIÓN paso a paso:
-- a.actor_id, a.first_name, a.last_name → muestra datos básicos del actor.
-- GROUP_CONCAT(DISTINCT ...) AS film_info → crea una lista de categorías y películas en las que actuó.
-- CONCAT(c.name, ': ', subconsulta) → arma la categoría y las películas asociadas, por ejemplo: "Action: Film1, Film2".
-- La SUBCONSULTA:
--     SELECT GROUP_CONCAT(f.title ...) → concatena los títulos de películas
--     JOIN con film_category y film_actor → para relacionar actor con películas y categorías
--     WHERE fc.category_id = c.category_id AND fa2.actor_id = a.actor_id → filtra solo los de esa categoría y actor
-- Todo esto genera algo como:
-- "Action: Film1, Film2; Comedy: Film3, Film4" → agrupado por actor.

-- 6. Materialized Views - Explicación

-- ¿Qué es una Materialized View?
-- Es una "vista materializada", es decir, una consulta pre-ejecutada que guarda físicamente los datos en disco.
-- A diferencia de una VIEW normal (virtual), una materialized view sí guarda datos reales y mejora el rendimiento.

-- ¿Para qué se usa?
-- - Consultas muy pesadas que no cambian seguido
-- - Reportes que se consultan frecuentemente (ej. estadísticas de ventas, acumulados)
-- - Mejorar performance evitando recomputar joins y agregaciones cada vez

-- ¿Cuándo se actualiza?
-- Depende del DBMS:
-- - Manualmente (REFRESH MATERIALIZED VIEW)
-- - Automáticamente con intervalos programados
-- - En algunos casos, se puede actualizar cada vez que cambia la tabla fuente (rare)

-- ¿Dónde se puede usar?
-- - PostgreSQL → sí (soporte nativo)
-- - Oracle → sí (muy completo)
-- - SQL Server → no directamente, pero se puede simular con indexed views
-- - MySQL → no nativamente, pero se puede simular con tablas temporales o triggers + insert

-- Alternativas en MySQL:
-- - Crear una tabla con los resultados de la consulta y actualizarla con un evento programado
-- - Usar procedimientos almacenados para regenerar los datos
-- - Usar caché de aplicación para guardar los resultados