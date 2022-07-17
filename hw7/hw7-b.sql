/**********************************************************************
 * NAME: Katie Stevens
 * CLASS: CPSC 321 Database Management Systems
 * DATE: 11/11/21
 * HOMEWORK: HW7
 * DESCRIPTION: 
 **********************************************************************/

USE cpsc321;

-- TODO: add queries with comments below

-- (a)
-- This query finds film rentals whose rate is greater than or equal to $4.99. It returns
-- title, rating, and rental_rate ordered by rating then alphabetically by title.
SELECT title, rating, rental_rate
FROM film
WHERE rental_rate >= 4.99
ORDER BY rating, title;


-- (b)
-- This query finds the total amount paid per customer.
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount)
FROM customer c JOIN payment p USING (customer_id)
GROUP BY p.customer_id;


-- (c)
-- This query returns an actors id, their first name, last name, and 
-- the number of films they were in. It only shows the first 15 actors.
SELECT fa.actor_id, a.first_name, a.last_name, COUNT(*)
FROM film_actor fa JOIN actor a USING (actor_id)
GROUP BY actor_id
LIMIT 15;


-- (d)
-- This query returns film title and category name organized by category and film title alphebetically.
SELECT f.title, c.name
FROM category c JOIN film_category fc USING (category_id)
     JOIN film f USING (film_id)
ORDER BY fc.category_id, f.title;


-- (e)
-- Choosing staff_id = 1
-- This query returns the first and last name of the staff, the customer id, the customer's
-- first and last name, and the payment amount for payments that were under 2.00 and were
-- transacted with staff_id 1.
SELECT s.first_name, s.last_name, c.customer_id, c.first_name, c.last_name, p.amount
FROM payment p JOIN staff s USING (staff_id)
     JOIN customer c USING (customer_id)
WHERE p.amount < 2.00 AND s.staff_id = 1;