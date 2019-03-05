use sakila;

# 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name FROM actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. 
# Name the column Actor Name.

SELECT upper(concat(first_name, ' ' , last_name)) as "Actor Name" FROM actor;

# 2a. find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 

SELECT first_name, actor_id, last_name 
FROM actor
WHERE first_name = 'Joe';

# 2b. Find all actors whose last name contain the letters GEN:

SELECT actor_id, first_name, last_name 
FROM actor
WHERE last_name LIKE '%GEN%';

# 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

SELECT actor_id, first_name, last_name 
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

# 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT country_id, country FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

# 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB

ALTER TABLE actor
ADD COLUMN description BLOB;

# 3b. Delete the description column.

ALTER TABLE actor
DROP COLUMN description;

# 4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name, COUNT(last_name) AS "Actor_Last_Name"
FROM actor
GROUP BY last_name;

# 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT last_name, count(last_name) AS "Actor_Last_Name"
FROM actor
GROUP BY last_name
HAVING `Actor_Last_Name` >=2;

# 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

# 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.

UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

# 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

# 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT s.first_name, s.last_name, a.address
FROM staff s
INNER JOIN address a 
ON (s.address_id = a.address_id);

# 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

SELECT s.first_name, s.last_name, SUM(p.amount) AS "Total for 2005"
FROM staff AS s
JOIN payment AS p ON s.staff_id = p.staff_id
WHERE MONTH(p.payment_date) = 08 AND YEAR(p.payment_date) = 2001
GROUP BY s.staff_id;

# 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT f.title, count(fa.actor_id) as "Number of Actors in Film"
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY f.title;

# 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT title, COUNT(inventory_id) AS "Number of Copies"
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
where f.title = 'Hunchback Impossible';

# 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

SELECT c.first_name, c.last_name, SUM(p.amount) AS "Total PER Customer"
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;

# 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT title
FROM film
WHERE 
(
title LIKE "K%" OR title LIKE "Q%"
) 
	AND language_id IN 
    (
		SELECT language_id 
        FROM language
		WHERE name = 'English'
	);

# 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name 
FROM actor
WHERE actor_id IN 
(
	SELECT actor_id 
    FROM film_actor
    WHERE film_id IN 
    (
		SELECT film_id 
        FROM film 
        WHERE title = 'Alone Trip'
		)
	);
    
    
# 7c  You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT first_name, last_name, email, country
FROM customer c
INNER JOIN address a
ON (c.address_id = a.address_id)
INNER JOIN city ci
ON (a.city_id = ci.city_id)
INNER JOIN country ct
ON (ci.country_id = ct.country_id)
WHERE ct.country = "canada";


# 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title, c.name
FROM film f
INNER JOIN film_category cat ON (f.film_id = cat.film_id)
INNER JOIN category c ON cat.category_id = c.category_id
WHERE c.name = 'Family';

# 7e. Display the most frequently rented movies in descending order.
SELECT title, COUNT(title) AS "Rental_Frequency"
FROM film f
INNER JOIN inventory i
ON (f.film_id = i.film_id)
INNER JOIN rental r 
ON (i.inventory_id = r.inventory_id)
GROUP BY title
ORDER BY (rental_frequency) DESC;

# 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT  s.store_id, concat(a.address, ', ', c.city, ', ', t.country) AS Store, sum(p.amount) AS "Business in Dollars"
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s ON i.store_id = s.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
JOIN country t ON c.country_id = t.country_id
GROUP BY s.store_id;

# 7g. Write a query to display for each store its store ID, city, and country.
SELECT  s.store_id, concat(a.address, ', ', c.city, ', ', t.country) AS Address
FROM store s 
INNER JOIN address a ON s.address_id = a.address_id
INNER JOIN city c ON a.city_id = c.city_id
INNER JOIN country t ON c.country_id = t.country_id;

# 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT SUM(amount) AS 'Revenue', c.name AS 'Genre'
FROM payment p
INNER JOIN rental r ON (p.rental_id = r.rental_id)
INNER JOIN inventory i ON (r.inventory_id = i.inventory_id)
INNER JOIN film_category cat ON (i.film_id = cat.film_id)
INNER JOIN category c ON (cat.category_id = c.category_id)
GROUP BY c.name
ORDER BY SUM(amount) DESC;


# 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE OR REPLACE VIEW top_five_genres AS
SELECT SUM(amount) AS 'Revenue', c.name AS 'Genre'
FROM payment p
INNER JOIN rental r ON (p.rental_id = r.rental_id)
INNER JOIN inventory i ON (r.inventory_id = i.inventory_id)
INNER JOIN film_category cat ON (i.film_id = cat.film_id)
INNER JOIN category c ON (cat.category_id = c.category_id)
GROUP BY c.name
ORDER BY SUM(amount) DESC
#top five only
LIMIT 5;

# 8b. How would you display the view that you created in 8a?
SELECT * 
FROM top_five_genres;

# 8b. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five_genres;