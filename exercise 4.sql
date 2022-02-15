########################## ASSIGNMENT 4a SQL ##############################

# Name: Yeying Zhuo
# Date: Oct 28th, 2021

####### INSTRUCTIONS #######

# Read through the whole template and read each question carefully.  Make sure to follow all instructions.

# Each question should be answered with only one SQL query per question, unless otherwise stated.
# All queries must be written below the corresponding question number.
# Make sure to include the schema name in all table references (i.e. sakila.customer, not just customer)
# DO NOT modify the comment text for each question unless asked.
# Any additional comments you may wish to add to organize your code MUST be on their own lines and each comment line must begin with a # character
# If a question asks for specific columns and/or column aliases, they MUST be followed.
# Pay attention to the requested column aliases for aggregations and calculations. Otherwise, do not re-alias columns from the original column names in the tables unless asked to do so.
# Return columns in the order requested in the question.
# Do not concatenate columns together unless asked.

# Refer to the Sakila documentation for further information about the tables, views, and columns: https://dev.mysql.com/doc/sakila/en/

##########################################################################

## Desc: Joining Data, Nested Queries, Views and Indexes, Transforming Data

############################ PREREQUESITES ###############################

# These queries make use of the Sakila schema.  If you have issues with the Sakila schema, try dropping the schema and re-loading it from the scripts provided with Assignment 2.

# Run the following two SQL statements before beginning the questions:
SET SQL_SAFE_UPDATES=0;
UPDATE sakila.film SET language_id=6 WHERE title LIKE "%ACADEMY%";

############################### QUESTION 1 ###############################

# 1a) List the actors (first_name, last_name, actor_id) who acted in more then 25 movies.  Also return the count of movies they acted in, aliased as movie_count. Order by first and last name alphabetically.
SELECT
a.first_name,
a.last_name,
a.actor_id,
COUNT(f.film_id) AS movie_count
FROM actor a INNER JOIN film_actor f ON a.actor_id = f.actor_id
GROUP BY a.actor_id
HAVING COUNT(f.film_id) > 25
ORDER BY a.first_name, a.last_name;
# 1b) List the actors (first_name, last_name, actor_id) who have worked in German language movies. Order by first and last name alphabetically.
SELECT
a.first_name,
a.last_name,
l.language_id
FROM actor a INNER JOIN film_actor f ON a.actor_id = f.actor_id
				INNER JOIN film i ON f.film_id = i.film_id
                INNER JOIN language l ON l.language_id = i.language_id
WHERE l.language_id = 6
ORDER BY a.first_name, a.last_name;
# 1c) List the actors (first_name, last_name, actor_id) who acted in horror movies and the count of horror movies by each actor.  Alias the count column as horror_movie_count. Order by first and last name alphabetically.
SELECT
a.first_name,
a.last_name,
y.category_id,
COUNT(y.category_id) AS horror_movie_count
FROM actor a INNER JOIN film_actor f ON a.actor_id = f.actor_id
				INNER JOIN film i ON f.film_id = i.film_id
                INNER JOIN film_category y ON f.film_id = y.film_id
                INNER JOIN category c ON c.category_id= y.category_id
WHERE y.category_id = 11
GROUP BY a.first_name, a.last_name
ORDER BY a.first_name, a.last_name;
# 1d) List the customers who rented more than 3 horror movies.  Return the customer first and last names, customer IDs, and the horror movie rental count (aliased as horror_movie_count). Order by first and last name alphabetically.
SELECT
c.first_name,
c.last_name,
y.category_id,
COUNT(y.category_id) AS horror_movie_count
FROM customer c INNER JOIN rental r ON c.customer_id = r.customer_id
				INNER JOIN inventory i ON i.inventory_id = r.inventory_id
                INNER JOIN film f ON f.film_id = i.film_id
                INNER JOIN film_category y ON f.film_id= y.film_id
WHERE y.category_id = 11
GROUP BY c.first_name, c.last_name
HAVING COUNT(y.category_id) > 3
ORDER BY C.first_name, C.last_name;
# 1e) List the customers who rented a movie which starred Scarlett Bening.  Return the customer first and last names and customer IDs. Order by first and last name alphabetically.
SELECT
c.first_name,
c.last_name,
c.customer_id
FROM customer c INNER JOIN rental r ON c.customer_id = r.customer_id
				INNER JOIN inventory i ON i.inventory_id = r.inventory_id
                INNER JOIN film f ON f.film_id = i.film_id
                INNER JOIN film_actor a ON a.film_id= f.film_id
WHERE a.actor_id = 124
ORDER BY C.first_name, C.last_name;
# 1f) Which customers residing at postal code 62703 rented movies that were Documentaries?  Return their first and last names and customer IDs.  Order by first and last name alphabetically.
SELECT
c.first_name,
c.last_name,
c.customer_id
FROM customer c JOIN rental r ON c.customer_id = r.customer_id
				JOIN inventory i ON i.inventory_id = r.inventory_id
                JOIN film_category y ON i.film_id= y.film_id
                JOIN category a ON y.category_id= a.category_id
                JOIN address f ON f.address_id= c.address_id
WHERE a.name = 'Documentary' AND f.postal_code = '62703'
GROUP BY c.first_name, c.last_name, c.customer_id
ORDER BY c.first_name, c.last_name, c.customer_id;
# 1g) Find all the addresses (if any) where the second address line is not empty and is not NULL (i.e., contains some text).  Return the address_id and address_2, sorted by address_2 in ascending order.
SELECT
address_id,
address2
FROM address
WHERE (address2 IS NOT NULL) AND (address2 <>'')
ORDER BY address2 ASC;
# 1h) List the actors (first_name, last_name, actor_id)  who played in a film involving a “Crocodile” and a “Shark” (in the same movie).  Also include the title and release year of the movie.  Sort the results by the actors’ last name then first name, in ascending order.
SELECT first_name, last_name, release_year, title 
FROM film f 
INNER JOIN film_actor l ON l.film_id = f.film_id
INNER JOIN actor a ON l.actor_id = a.actor_id
WHERE description LIKE "%Crocodile%" AND description LIKE "%Shark%"
ORDER BY last_name ASC, first_name ASC;
# 1i) Find all the film categories in which there are between 55 and 65 films. Return the category names and the count of films per category, sorted from highest to lowest by the number of films.  Alias the count column as count_movies. Order the results alphabetically by category.
SELECT name, COUNT(film_id) as count_movies
FROM film_category f INNER JOIN category c ON c.category_id=f.category_id
GROUP BY f.category_id
HAVING count_movies > 55 AND count_movies < 65
ORDER BY name;
# 1j) In which of the film categories is the average difference between the film replacement cost and the rental rate larger than $17?  Return the film categories and the average cost difference, aliased as mean_diff_replace_rental.  Order the results alphabetically by category.
SELECT name AS category_name , (AVG(replacement_cost) - AVG(rental_rate)) AS mean_diff_replace_rental
FROM film_category 
INNER JOIN film USING (film_id)
INNER JOIN category USING (category_id)
GROUP BY category_id 
HAVING mean_diff_replace_rental > 17
ORDER BY name;
# 1k) Create a list of overdue rentals so that customers can be contacted and asked to return their overdue DVDs. Return the title of the film, the customer first name and last name, customer phone number, and the number of days overdue, aliased as days_overdue.  Order the results by first and last name alphabetically.
## NOTE: To identify if a rental is overdue, find rentals that have not been returned and have a rental date further in the past than the film's rental duration (rental duration is in days)
SELECT c.first_name, c.last_name, f.title, a.phone, f.rental_duration AS days_overdue
FROM rental r INNER JOIN customer c ON r.customer_id = c.customer_id
				INNER JOIN address a ON c.address_id = a.address_id
                INNER JOIN inventory i ON r.inventory_id = i.inventory_id
                INNER JOIN film f ON i.film_id = f.film_id
WHERE r.return_date IS NULL
AND rental_date + INTERVAL f.rental_duration DAY < CURRENT_DATE()
ORDER BY c.first_name, c.last_name;
# 1l) Find the list of all customers and staff for store_id 1.  Return the first and last names, as well as a column indicating if the name is "staff" or "customer", aliased as person_type.  Order results by first name and last name alphabetically.
## Note : use a set operator and do not remove duplicates
ALTER TABLE customer ADD person_type char(10) NOT NULL
UPDATE customer SET person_type = 'customer'
ALTER TABLE staff ADD person_type char(10)
UPDATE staff SET person_type = 'staff'
(SELECT first_name, 
        last_name,
        person_type
 FROM customer
 WHERE store_id = 1)
UNION ALL
(SELECT first_name, 
        last_name,
        person_type
 FROM staff
 WHERE store_id = 1)
############################### QUESTION 2 ###############################

# 2a) List the first and last names of both actors and customers whose first names are the same as the first name of the actor with actor_id 8.  Order in alphabetical order by last name.
## NOTE: Do not remove duplicates and do not hard-code the first name in your query.
(SELECT customer_id AS id, 
        first_name, 
        last_name
 FROM customer
 WHERE first_name = (SELECT first_name FROM actor WHERE actor_id = 8))
UNION ALL
(SELECT actor_id AS id, 
        first_name, 
        last_name
 FROM actor
 WHERE first_name = (SELECT first_name FROM actor WHERE actor_id = 8))
# 2b) List customers (first name, last name, customer ID) and payment amounts of customer payments that were greater than average the payment amount.  Sort in descending order by payment amount.
## HINT: Use a subquery to help
SELECT c.first_name, c.last_name, c.customer_id, p.amount
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
WHERE amount > (SELECT AVG(amount) FROM payment)
ORDER BY amount DESC;
# 2c) List customers (first name, last name, customer ID) who have rented movies at least once.  Order results by first name, lastname alphabetically.
## Note: use an IN clause with a subquery to filter customers
SELECT c.first_name, c.last_name, c.customer_id
FROM customer c JOIN rental r ON c.customer_id = r.customer_id
WHERE rental_id IN
(SELECT rental_id FROM rental GROUP BY rental_id HAVING COUNT(*)>=1)
ORDER BY c.first_name, c.last_name;
# 2d) Find the floor of the maximum, minimum and average payment amount.  Alias the result columns as max_payment, min_payment, avg_payment.
SELECT floor(MAX(amount)) AS max_payment,
		floor(MIN(amount)) AS min_payment,
        floor(AVG(amount)) AS avg_payment
FROM payment;
############################### QUESTION 3 ###############################

# 3a) Create a view called actors_portfolio which contains the following columns of information about actors and their films: actor_id, first_name, last_name, film_id, title, category_id, category_name
CREATE VIEW actors_portfolio AS
    SELECT 
        a.actor_id, a.first_name, a.last_name, f.film_id, f.title, c.category_id, c.name AS category_name
    FROM
        actor a INNER JOIN film_actor r ON r.actor_id=a.actor_id
				INNER JOIN film f ON f.film_id=r.film_id
                INNER JOIN film_category y ON y.film_id = f.film_id
                INNER JOIN category c ON y.category_id=c.category_id;
# 3b) Describe (using a SQL command) the structure of the view.
DESCRIBE actors_portfolio;
# 3c) Query the view to get information (all columns) on the actor ADAM GRANT
SELECT * 
FROM actors_portfolio 
WHERE (first_name = 'ADAM') AND (last_name = 'GRANT');
# 3d) Insert a new movie titled Data Hero in Sci-Fi Category starring ADAM GRANT
## NOTE: If you need to use multiple statements for this question, you may do so.
## WARNING: Do not hard-code any id numbers in your where criteria.
## !! Think about how you might do this before reading the hints below !!
## HINT 1: Given what you know about a view, can you insert directly into the view? Or do you need to insert the data elsewhere?
## HINT 2: Consider using SET and LAST_INSERT_ID() to set a variable to aid in your process.
INSERT INTO sakila.film(`title`,`language_id`) VALUES ('Data Hero', 1);
INSERT INTO sakila.film_actor(`film_id`,`actor_id`) SELECT last_insert_id(), actor_id FROM sakila.actor WHERE first_name = 'ADAM' AND last_name = 'GRANT';
INSERT INTO sakila.film_category(`film_id`,`category_id`) SELECT last_insert_id(), category_id FROM sakila.category WHERE name = 'Sci-Fi';
############################### QUESTION 4 ###############################

# 4a) Extract the street number (numbers at the beginning of the address) from the customer address in the customer_list view.  Return the original address column, and the street number column (aliased as street_number).  Order the results in ascending order by street number.
## NOTE: Use Regex to parse the street number
SELECT cast(SUBSTRING_INDEX(address,' ',1) AS double) AS street_number, address 
FROM customer_list
ORDER BY street_number;
# 4b) List actors (first name, last name, actor id) whose last name starts with characters A, B or C.  Order by first_name, last_name in ascending order.
## NOTE: Use either a LEFT() or RIGHT() operator
SELECT first_name, last_name
FROM actor
WHERE last_name REGEXP '^(A|B|C)'
ORDER BY first_name ASC, last_name ASC;
# 4c) List film titles that contain exactly 10 characters.  Order titles in ascending alphabetical order.
SELECT title FROM film
WHERE title REGEXP '^.{10}$'
ORDER BY title ASC;
# 4d) Return a list of distinct payment dates formatted in the date pattern that matches "22/01/2016" (2 digit day, 2 digit month, 4 digit year).  Alias the formatted column as payment_date.  Retrn the formatted dates in ascending order.
SELECT DATE_FORMAT(payment_date, '%d-%m-%Y')  AS payment_date
FROM payment
ORDER BY payment_date ASC;
# 4e) Find the number of days each rental was out (days between rental_date & return_date), for all returned rentals.  Return the rental_id, rental_date, return_date, and alias the days between column as days_out.  Order with the longest number of days_out first.
SELECT rental_id, rental_date, return_date, DATEDIFF(return_date,rental_date) AS days_out
FROM rental
ORDER BY days_out DESC;