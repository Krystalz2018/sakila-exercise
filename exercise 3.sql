############################### ASSIGNMENT 3 ###################################
# Name: Yeying Zhuo
# Date: October 19th, 2021

####### INSTRUCTIONS #######

# Read through the whole template and read each question carefully.  Make sure to follow all instructions.

# Each question should be answered with only one SQL query per question
# All queries must be written below the corresponding question number.
# Make sure to include the schema name in all table references (i.e. sakila.customer, not just customer)
# DO NOT modify the comment text or add additional comments unless asked.
# If a question asks for specific columns and/or column aliases, they must be followed.
# Pay attention to the requested column aliases for aggregations and calculations. Otherwise, do not re-alias columns from the original column names in the tables unless asked to do so.
# Do not concatenate columns together unless asked.

# Refer to the Sakila documentation for further information about the tables, views, and columns: https://dev.mysql.com/doc/sakila/en/

#########################################################################

## Desc: Manipulating, Categorizing, Sorting and Grouping & Summarizing Data

############################### PREREQUESITES ############################

# Run the following two SQL statements before beginning the questions:
SET SQL_SAFE_UPDATES=0;
UPDATE film SET language_id=6 WHERE title LIKE "%ACADEMY%";
DROP TABLE sakila.payment_type IF EXISTS;

############################### QUESTION 1 ###############################

# 1a) Count the total number of records in the actor table.  Alias the result column as count_records.
select
count(*) as count_records
from actor;
# 1b) List is the first name and last name of all the actors in the actor table.
select 
first_name, last_name
from actor;
# 1c) Insert a new record into the actors table with your first name and the first letter of your last name (not your full last name).
INSERT INTO `actor` 
	(`actor_id`,`first_name`,`last_name`,`last_update`)
VALUES
('201','Yeying','Z','2021-10-19 17:33:33');
# 1d) Update the record you inserted just into the actors table, and change the first letter of your last name to your full last name.  Make sure to only update that one record.
update actor
set
last_name = 'Zhuo'
where
first_name = 'Yeying';
# 1e) Delete the record from the actor table that you just entered.  Make sure to only delete that one record.
delete from actor
where first_name = 'Yeying';
# 1f) Create a table payment_type with the following specifications and appropriate data types
## Table Name : ???payment_type???
## Primary Key: "payment_type_id??? (auto incrementing, not null)
## Column: ???type??? (not null)
create table `payment_type` (
`payment_type_id` INT NOT NULL auto_increment,
`type` VARCHAR(50) NOT NULL,
primary key (`payment_type_id`)
);
# 1g) Insert the following rows in to the payment_type table: 1, ???Credit Card??? ; 2, ???Cash???; 3, ???Paypal??? ; 4 , ???Cheque???
## Note: Make use of the auto-incrementing primary key.
insert into `payment_type`
	(`type`)
values
('Credit Card'),
('Cash'),
('Paypal'),
('Cheque');
# 1h) Rename table payment_type to payment_types.
RENAME TABLE payment_type TO payment_types;
# 1i) Drop the table payment_types.
DROP TABLE payment_types;
############################### QUESTION 2 ###############################

# 2a) List the title and description of all movies rated PG-13.
SELECT
title, description
FROM film
WHERE rating = 'PG-13';
# 2b) List the title of all movies that are either PG OR PG-13, using IN operator.
SELECT
title
FROM film
WHERE rating IN ('PG','PG-13');
# 2c) Report the payment_id and payment amount for all payments greater than or equal to $2 and less than or equal to $7, using the BETWEEN operator.
SELECT
payment_id, amount
FROM payment
WHERE amount BETWEEN 2 AND 7;
# 2d) List all addresses that have phone number that contain digits 589, start with 140, or end with 323.  Return all columns in the address table for the matching records.
SELECT
address, phone
FROM address
WHERE (phone LIKE '%589%') OR (phone LIKE '140%') OR (phone LIKE '%323');
# 2e) List all staff members (first name, last name, email) whose password is NULL
SELECT
first_name, last_name
FROM staff
WHERE password is NULL;
# 2f) Select all films that have titles containing the word ZOO and have a rental duration greater than or equal to 4.  Return the title and rental duration.
SELECT
title, rental_duration
FROM film
WHERE 
title LIKE '%ZOO%'
AND rental_duration >=4;
# 2g) What is the cost of renting the movie ACADEMY DINOSAUR for 12 days?  Aias the calculated column as rental_cost.
# Note: the rental_rate is per the number of days specified in rental_duration. See the Sakila documentation for more information about the columns.
SELECT
(rental_rate/rental_duration*12) AS rental_cost
FROM film
WHERE title = 'ACADEMY DINOSAUR';
# 2h) List all the unique cities in the address table.
SELECT
DISTINCT city
FROM city;
# 2i) List the first name, last name, and customer ID of the top 10 newest customers across all stores.
SELECT
first_name, last_name, customer_id, create_date
FROM
customer
ORDER BY create_date DESC
LIMIT 10;
############################### QUESTION 3 ###############################

# 3a) What is the minimum payment received and max payment received across all transactions?  Alias the result columns as min_payment and max_payment.
SELECT
MAX(amount) AS max_payment,
MIN(amount) AS min_payment
FROM payment;
# 3b) How many customers rented movies between Feb 2005 & May 2005 (based on rental_date)? Alias the result column as num_customers.
SELECT COUNT(customer_id) AS num_customers
FROM rental
WHERE rental_date BETWEEN CAST('2005-02-01' AS DATE) AND CAST('2005-05-31' AS DATE);
# 3c) List all movies where replacement_cost is greater than $15 OR the rental_duration is between 6 & 10 days. Return the title, replacement_cost, and rental_duration.
SELECT title, replacement_cost, rental_duration
FROM film
WHERE (replacement_cost > 15) OR (rental_duration BETWEEN 6 AND 10);
# 3d) What is the total amount spent by customers to rent movies in the year 2005? Alias the result column as total_spent.
SELECT SUM(amount) AS total_spent
FROM payment
WHERE payment_date LIKE '%2005%';
# 3e) What is the average replacement cost across all movies? Alias the result column as avg_replacement_cost.
SELECT AVG(replacement_cost) AS avg_replacement_cost
FROM film;
# 3f) What is the standard deviation of rental rate across all movies? Alias the result column as std_rental_rate.
SELECT STD(rental_rate) AS std_rental_rate
FROM film;
# 3g) What is the midrange of the rental duration for all movies? Alias the result as midrange_duration.
SELECT (max(rental_duration)+min(rental_duration))/2 AS midrange_duration
FROM film;
############################### QUESTION 4 ###############################

# 4a) List the count of movies that are either G, NC-17, PG-13, PG, or R, grouped by rating. Alias the count column as movie_count
SELECT COUNT(title) AS movie_count
FROM film
WHERE rating IN ('G', 'NC-17', 'PG', 'R')
GROUP BY rating;
# 4b) Find the movies where rental rate is greater than $1 and order result set by descending order. Return the movie title and rental rate.
SELECT title, rental_rate
FROM film
WHERE rental_rate>1
ORDER BY rental_rate DESC;
# 4c) Find the top 2 movies rated R that have the highest replacement costs.  Return the movie title, rating, and replacement cost.  If you need to break a tie between multiple movies with the same highest replacment cost, use additional alphabetical ordering by title.
SELECT title, rating, replacement_cost
FROM film
WHERE rating = 'R'
ORDER BY replacement_cost DESC
LIMIT 2;
# 4d) Find the most frequently occurring (mode) rental rate across products.  Return only the rental rate, aliased as mode_rental_rate
SELECT rental_rate AS mode_rental_rate
FROM film
GROUP BY rental_rate
ORDER BY COUNT(*) DESC
LIMIT 1;
# 4e) Find the top 2 longest movies with movie length greater than 50 mins AND which has commentaries as a special features. Return the movie title and length.  If you need to break a tie between multiple movies with the same length, use additional alphabetical ordering by title.
SELECT title, length
FROM film
WHERE (length > 50) AND (special_features = 'commentaries')
ORDER BY length DESC
LIMIT 2;
# 4f) List the top 5 movies (in alphabetical order) whose titles start with Z, are NOT rated R, and have a rental duration less than 7 days.  Use a not-equals operator to filter the rating.  Return the movie title, rating, and rental duration.
SELECT title, rating, rental_duration
FROM film
WHERE (title LIKE 'Z%') AND (rating != 'R') AND (rental_duration<7)
ORDER BY title ASC
LIMIT 5;