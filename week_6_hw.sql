/*
Week O6 Homework File 
Lilla Bartkó
17 Nov 2021
*/

/*  1. Show all customers whose last names start with 
T. Order them by first name from A-Z. */

SELECT public.customer.first_name AS first_name, 
		public.customer.last_name AS last_name
FROM public.customer
WHERE last_name LIKE ('T%')
ORDER BY first_name ASC;

/****************************************************/

/* 2.Show all rentals returned from 5/28/2005 to 
6/1/2005. */

SELECT f.title, r.return_date
FROM public.rental AS r

	JOIN public.inventory AS i
	ON r.inventory_id = i.inventory_id
	
	JOIN public.film as f
	ON f.film_id = i.film_id
	
WHERE r.return_date BETWEEN '2005-05-28 00:00:00' 
	AND '2005-06-02 00:00:00'

ORDER BY r.return_date DESC; 

/* I chose to order by return date from the most 
recent return because I wanted to make sure that 
I captured returns ON the given end date. */

/****************************************************/

/* 3. How would you determine which movies are rented 
the most? */

SELECT title, COUNT(title) AS times_rented
FROM film AS f	
	INNER JOIN inventory as i
	ON f.film_id = i.film_id
	INNER JOIN rental AS r
	ON i.inventory_id = r.inventory_id
GROUP BY title
ORDER BY times_rented DESC;

/* EXPLANATION OF PROBLEM HERE*/

/****************************************************/


/* 4. Show how much each customer spent on movies 
(for all time) . Order them from least to most. */

SELECT first_name, last_name, 
	SUM(p.amount) AS sum_total_payments
FROM customer AS c
	INNER JOIN payment AS p 
	ON c.customer_id = p.customer_id
GROUP BY p.customer_id, last_name, first_name
ORDER BY sum_total_payments;

/* We use the payment and customer tables and join 
them on customer id. We sum the amount and alias as
total amount paid. We display the first and last name
of the customer. We order by the sum, from least to 
most (default). */

/****************************************************/

/* 5. Which actor was in the most movies in 2006 
(based on this dataset)? Be sure to alias the actor 
name and count as a more descriptive name. Order the 
results from most to least. */

/* EXPLANATION OF PROBLEM HERE*/

/****************************************************/

/* 6. Write an explain plan for 4 and 5. Show the 
queries and explain what is happening in each one. 
Use the following link to understand how this works 
http://postgresguide.com/performance/explain.html  */

/* EXPLANATION OF PROBLEM HERE*/

/****************************************************/

/* 7. What is the average rental rate per genre? */

SELECT c.name AS genre, 
	ROUND(AVG(f2.rental_rate),2) AS avg_rental_rate
FROM category AS c
	JOIN film_category AS f1
		ON c.category_id = f1.category_id 
	JOIN film AS f2
		ON f1.film_id = f2.film_id
GROUP BY genre
ORDER BY avg_rental_rate DESC;

/* EXPLANATION OF PROBLEM HERE*/

/****************************************************/

/* 8. How many films were returned late? Early? On time? */

SELECT 	CASE
       		WHEN rental_duration > DATE_PART('day', return_date-rental_date)
				THEN 'Early'
        	WHEN rental_duration = DATE_PART('day' , return_date-rental_date)
				THEN 'On Time'
					ELSE 'Late'
		END AS "Return Status",
		COUNT(*) AS "Total Films"
FROM film AS f
	INNER JOIN inventory AS i
		ON f.film_id=i.film_id
	INNER JOIN rental AS r
		ON i.inventory_id=r.inventory_id
GROUP BY "Return Status"
ORDER BY "Total Films" DESC;

/* EXPLANATION OF PROBLEM HERE*/

/****************************************************/

/* 9. What categories are the most rented and what are
their total sales? */
/*
(like most frequently rented movies question)
but here I"m answring top genres in gross revenue
*/

SELECT name AS genre, SUM(amount) AS total_sales
FROM rental
	JOIN inventory 
	USING (inventory_id)
	JOIN payment
	USING (rental_id)
	JOIN film_category
	USING (film_id)
	JOIN category 
	USING (category_id)
GROUP BY name
ORDER BY total_sales DESC;

/* EXPLANATION OF PROBLEM HERE*/

/****************************************************/

/* 10. Create a view for 8 and a view for 9. Be sure 
to name them appropriately.  */

/** For 8: to show which films were returned early, on
time, or late: **/
CREATE VIEW Rental_Return_Status AS
SELECT 	CASE
       		WHEN rental_duration > DATE_PART('day', return_date - rental_date)
				THEN 'Early'
        	WHEN rental_duration = DATE_PART('day' , return_date - rental_date)
				THEN 'On Time'
					ELSE 'Late'
		END AS "Return Status",
		COUNT(*) AS "Total Films"
FROM film AS f
	INNER JOIN inventory AS i
		ON f.film_id=i.film_id
	INNER JOIN rental AS r
		ON i.inventory_id=r.inventory_id
GROUP BY "Return Status"
ORDER BY "Total Films" DESC;

/* To display the view: */
SELECT * FROM Rental_Return_Status;

/** For 9: to inspect the five categories with highest 
revenues: **/

CREATE VIEW Top_5_Grossing_Genres AS
SELECT name AS genre, SUM(amount) AS total_sales
FROM rental
	JOIN inventory 
	USING (inventory_id)
	JOIN payment
	USING (rental_id)
	JOIN film_category
	USING (film_id)
	JOIN category 
	USING (category_id)
GROUP BY name
ORDER BY total_sales DESC
LIMIT 5;*/

/* To display the view: */

SELECT * FROM Top_5_Grossing_Genres;


/* EXPLANATION OF PROBLEM HERE*/

/****************************************************/

/* BONUS: Write a query that shows how many films were 
rented each month. Group them by category and month. 

/* EXPLANATION OF PROBLEM HERE*/

/****************************************************/