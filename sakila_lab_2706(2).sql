Use sakila;

----- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(inventory_id) as number_of_copies, f.title 
FROM sakila.film f
JOIN sakila.inventory i USING (film_id)
WHERE f.title='Hunchback Impossible';

----- List all films whose length is longer than the average of all the films.
SELECT title, length FROM film
WHERE length > (
  SELECT avg(length)
  FROM film
)
ORDER BY length desc;

----- Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor 
WHERE actor_id IN (
SELECT actor_id FROM film_actor 
WHERE film_id IN (
SELECT film_id 
FROM film 
WHERE title = 'Alone Trip'));

----- Identify all movies categorized as family films
SELECT title
FROM film
WHERE film_id IN (
SELECT film_id FROM film_category
WHERE category_id IN (
SELECT category_id FROM category
WHERE name LIKE '%family%'));

----- Get name and email from customers from Canada 
----- using subqueries
SELECT first_name, last_name, email
FROM customer WHERE address_id IN (
SELECT address_id FROM address
WHERE city_id IN (
SELECT city_id FROM city WHERE country_id IN (
SELECT country_id FROM country
WHERE country = 'Canada')));

----- using joins
SELECT first_name, last_name, email
FROM customer 
JOIN address USING (address_id)
JOIN city USING (city_id)
JOIN country USING (country_id)
WHERE country = 'Canada';

----- Which are films starred by the most prolific actor?
----- First, the most prolific actor
SELECT actor_id, count(film_id) as num
FROM film_actor
GROUP BY actor_id 
ORDER BY num desc
LIMIT 1;
----- then use that actor_id to find the different films that he/she starred
SELECT title
FROM film WHERE film_id IN (SELECT film_id FROM film_actor
WHERE actor_id IN (
SELECT actor_id FROM( 
SELECT actor_id, count(film_id) as num
FROM film_actor
GROUP BY actor_id 
ORDER BY num desc
LIMIT 1)));
 -- doesnt work

SELECT first_name, last_name
FROM actor
WHERE actor_id = 107;


----- Films rented by most profitable customer
SELECT sum(amount) as 'sum of money', customer_id
FROM payment
GROUP BY customer_id
ORDER BY 'sum of money' desc
LIMIT 1;

SELECT first_name,last_name
FROM customer WHERE customer_id = 1;


SELECT first_name,last_name
FROM customer WHERE customer_id IN (
SELECT customer_id FROM rental WHERE customer_id IN(
SELECT sum(amount) as 'sum of money', customer_id
FROM payment
GROUP BY customer_id
ORDER BY 'sum of money' desc
LIMIT 1));  -- doesnt work

----- Customers who spent more than the average payments
SELECT first_name, last_name FROM customer
WHERE customer_id IN(
SELECT customer_id FROM rental
WHERE rental_id IN(
SELECT customer_id FROM payment
WHERE amount > (SELECT AVG(amount) FROM payment)));



