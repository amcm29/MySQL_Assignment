USE sakila;

# 1a Display the first and last name of all actors from the table actor

SELECT first_name, last_name FROM actor;

# 1b Display the first and last name of each actor in a single column in upper case letters. 
# Name the column Actor Name.

SELECT UPPER(CONCAT(first_name, " ", last_name)) AS Actor_Name from actor;

#  2aYou need to find the ID Number , first name, and lat name of an actor , of whom you know only the first name, "Joe"
# What is one query you would use to obtain his information?

SELECT actor_id, first_name, last_name AS Actor_Name_and_ID
FROM actor
WHERE first_name="Joe";

# 2b Find all actors whose last name contains the letters GEN

SELECT *
FROM actor
WHERE last_name LIKE "%GEN%";

#2c Find all actors whose last names contain the letters LI.
# This time, order the rows by last name and first name in that order.

SELECT last_name, first_name
FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name;

# 2d Using IN, display the country_id and country columns of the following countries:
# Afghanistan, Bangladesh, and China.

SELECT country_id, country
FROM country
WHERE country IN ("Afghanistan","Bangladesh", "China");

#  3a You want to keep a description of each actor. You don't think you will be performing queries on a 
# description, so create a column in the table actor named description and use the data type BLOB.alter
# (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).

ALTER TABLE actor 
    ADD Description BLOB(255);
SELECT * FROM actor;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
# Delete the description column.

ALTER TABLE actor 
    DROP COLUMN Description;
SELECT * FROM actor;

# 4a List the last names of acors, as well as how many actors have that last name,

SELECT DISTINCT last_name, 
COUNT(last_name) 
FROM actor
GROUP BY last_name;

# 4b List the last names of acors, as well as how many actors have that last name,
# but only for names that are shared by at least two actors

SELECT DISTINCT last_name, 
COUNT(last_name) AS name_count 
FROM actor
GROUP BY last_name
HAVING name_count >=2;

# 4c The actor HARPO WILLIAMS was acidentally entered in the actor table as GROUCHO WILLIAMS.
# Write a query to fix the record

SELECT first_name, last_name
FROM actor
WHERE last_name = "WILLIAMS" AND first_name="GROUCHO";

UPDATE actor
SET first_name="HARPO"
WHERE last_name = "WILLIAMS" AND first_name="GROUCHO";

SELECT first_name, last_name
FROM actor
WHERE last_name = "WILLIAMS" AND first_name="GROUCHO";

# 4d Perhaps we were too hasty in changing GROUCHO to HARPO.
# It turns out that GROUCHO was the correct name after all!
# In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.

UPDATE actor
SET first_name="GROUCHO"
WHERE last_name = "WILLIAMS" AND first_name="HARPO";

SELECT first_name, last_name
FROM actor
WHERE last_name = "WILLIAMS" AND first_name="HARPO";

#5a You cannot locate the schema of the address table. Which query would you use to re-create it?

SHOW CREATE TABLE address;

# 6a Use JOIN to display the first and last names, as well as the address of each staff member.
# Use the tables taff and address.

SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON staff.address_id = address.address_id;

# 6b Use JOIN to display the total amount rung up by each staff member in August of 2005.
# Use tables staff and payment.alter

SELECT staff.first_name, staff.last_name, payment.payment_date, SUM(payment.amount)
FROM staff
INNER JOIN payment ON staff.staff_id=payment.staff_id
WHERE payment_date LIKE "2005-08%"
GROUP BY payment.staff_id;

#6c  List each film and the number of actors who are listed for that film.
# Use tables film_actor and film. Use INNER JOIN.alter

SELECT title, COUNT(actor_id)
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY title;

# 6d How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT * FROM inventory;

SELECT inventory_id, COUNT(inventory.film_id), film.title
FROM inventory
INNER JOIN film ON inventory.film_id = film.film_id
WHERE film.title="HUNCHBACK IMPOSSIBLE"
GROUP BY inventory.film_id;

#6e Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
# List the customers alphabetically by last name.alter

SELECT customer.last_name, customer.first_name, SUM(amount)
FROM payment
INNER JOIN customer ON payment.customer_id = customer.customer_id
GROUP BY payment.customer_id
ORDER BY last_name ASC;

# 7a The music of Queen and Kris Kristofferson have seen an unlikely resurgence.  As an unintended 
# consequence, films starting with the letters K and Q have also soared in popularity.  Use subqueries 
# to display the titles of movies starting  with letters K and Q whose language is English.

SELECT title
FROM film
WHERE  language_id IN	
	(SELECT language_id
	FROM language
    WHERE name ="English")
	AND (title LIKE "K%") OR (title LIKE "Q%");
    
# 7b Use subqeries to display all actors who appear in the film Alone Trip.

SELECT * FROM film
WHERE title="Alone Trip";

SELECT * FROM film_actor
ORDER BY film_id ASC;

SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id IN(
	SELECT actor_id
	FROM film_actor 
	WHERE city LIKE 'Q%'
	);
    
    
SELECT first_name, last_name
FROM actor
WHERE actor_id IN	(
	SELECT actor_id
	FROM film_actor
    WHERE film_id IN (
		SELECT film_id
        FROM film
        WHERE title ="Alone Trip"
        )
	);
    
# 7c You want to run an email marketing campaign in Canada, for which you will need the names 
# and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT first_name, last_name, email
FROM customer
INNER JOIN address on customer.address_id = address.address_id
INNER JOIN city on address.city_id = city.city_id 
INNER JOIN country on city.country_id = country.country_id
WHERE country.country = 'Canada';

# 7d Sales have been lagging among young families, and you wish to target all faily movies for a promotion.
# Identify all movies characterized as family films.

SELECT * FROM category;

SELECT title
FROM film
WHERE film_id IN	(
	SELECT film_id
	FROM film_category
    WHERE category_id IN (
		SELECT category_id
        FROM category
        WHERE category.name ="Family"
        )
	);


# 7e Display the most frequently rented movies in descending order

SELECT title, COUNT(rental_id) AS NUMRENTALS
FROM film
INNER JOIN inventory on inventory.film_id = film.film_id
INNER JOIN rental on rental.inventory_id = inventory.inventory_id 
GROUP BY title ORDER BY NUMRENTALS DESC LIMIT 20;


# 7f Write a query to display how much business, in dollars, each store brought in

SELECT store_id, SUM(amount) AS SALES
from staff
INNER JOIN payment ON payment.staff_id=staff.staff_id
GROUP BY store_id;

# 7g Write a query to display for each store it's store id, city and country.

SELECT store_id, city, country
FROM store
INNER JOIN address on address.address_id = store.address_id
INNER JOIN city on address.city_id = city.city_id 
INNER JOIN country on city.country_id = country.country_id;

# 7h List the top five genres in gross revenue in descending order
# Hint: you may need to use the following tables: category, film_category, inventroy, payment and rental.

SELECT category.name, SUM(amount) AS GrossRevenue
from category
INNER JOIN film_category ON category.category_id=film_category.category_id
INNER JOIN inventory ON film_category.film_id=inventory.film_id
INNER JOIN rental ON inventory.inventory_id=rental.inventory_id
INNER JOIN payment ON rental.rental_id=payment.rental_id
GROUP BY category.name ORDER BY GrossRevenue DESC LIMIT 5;

# 8a In your new role as an executive, you would like to have an easy way of viewingthe top five genres
# by gross revenue.  Use the solution from the problem above to create a view. 

CREATE VIEW Top_Five_Genres AS
SELECT category.name, SUM(amount) AS GrossRevenue
from category
INNER JOIN film_category ON category.category_id=film_category.category_id
INNER JOIN inventory ON film_category.film_id=inventory.film_id
INNER JOIN rental ON inventory.inventory_id=rental.inventory_id
INNER JOIN payment ON rental.rental_id=payment.rental_id
GROUP BY category.name ORDER BY GrossRevenue DESC LIMIT 5;

#8b. How would you display the view that you created in 8a?
SELECT * FROM Top_Five_Genres;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW Top_Five_Genres