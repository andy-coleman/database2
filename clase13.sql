-- 1. Agregar un nuevo cliente a la Store 1 usando la dirección con mayor address_id en Estados Unidos
INSERT INTO customer (
  store_id, first_name, last_name, email, address_id, active, create_date
)
VALUES (
  1,
  'Andrés',
  'Gómez',
  'andres.gomez@email.com',
  (
    SELECT MAX(a.address_id)
    FROM address a
    JOIN city ci ON a.city_id = ci.city_id
    JOIN country co ON ci.country_id = co.country_id
    WHERE co.country = 'United States'
  ),
  1,
  NOW()
);

-- 2. Agregar un alquiler seleccionando por título de película y staff de Store 2
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (
  NOW(),
  (SELECT MAX(i.inventory_id)
   FROM inventory i
   JOIN film f ON f.film_id = i.film_id
   WHERE f.title = 'ACADEMY DINOSAUR'),
  (SELECT customer_id FROM customer LIMIT 1),
  (SELECT staff_id FROM staff WHERE store_id = 2 LIMIT 1)
);

-- 3. Actualizar año de lanzamiento de películas según el rating
UPDATE film SET release_year = 2001 WHERE rating = 'G';
UPDATE film SET release_year = 2002 WHERE rating = 'PG';
UPDATE film SET release_year = 2003 WHERE rating = 'PG-13';
UPDATE film SET release_year = 2004 WHERE rating = 'R';
UPDATE film SET release_year = 2005 WHERE rating = 'NC-17';

-- 4. Devolver una película (último alquiler sin devolución)
-- Paso 1: Obtener el último rental sin return_date
SELECT rental_id
FROM rental
WHERE return_date IS NULL
ORDER BY rental_date DESC
LIMIT 1;

-- Paso 2: Usar el rental_id obtenido (ejemplo: 16000)
UPDATE rental
SET return_date = NOW()
WHERE rental_id = 16000;

-- 5. Eliminar una película (por ejemplo: ACADEMY DINOSAUR)
-- Paso 1: Obtener film_id
SELECT film_id FROM film WHERE title = 'ACADEMY DINOSAUR';

-- Supongamos que el film_id es 1
-- Paso 2: Eliminar relaciones
DELETE FROM film_category WHERE film_id = 1;
DELETE FROM film_actor WHERE film_id = 1;
DELETE FROM inventory WHERE film_id = 1;

-- Paso 3: Eliminar la película
DELETE FROM film WHERE film_id = 1;

-- 6. Alquilar una película (buscar inventario disponible, agregar rental y payment)
-- Paso 1: Buscar inventory_id disponible
SELECT i.inventory_id
FROM inventory i
LEFT JOIN rental r ON i.inventory_id = r.inventory_id AND r.return_date IS NULL
WHERE i.store_id = 1 AND r.rental_id IS NULL
LIMIT 1;

-- Supongamos que es 300
-- Paso 2: Insertar en rental
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (
  NOW(),
  300,
  (SELECT customer_id FROM customer LIMIT 1),
  (SELECT staff_id FROM staff WHERE store_id = 1 LIMIT 1)
);

-- Paso 3: Insertar en payment
INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (
  (SELECT customer_id FROM customer LIMIT 1),
  (SELECT staff_id FROM staff WHERE store_id = 1 LIMIT 1),
  (SELECT rental_id FROM rental ORDER BY rental_date DESC LIMIT 1),
  4.99,
  NOW()
);