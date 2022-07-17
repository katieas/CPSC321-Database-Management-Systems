/**********************************************************************
 * NAME: Katie Stevens
 * CLASS: CPSC 321 Database Management Systems
 * DATE: 11/28/21
 * HOMEWORK: HW8
 * DESCRIPTION: movie rental queries
 **********************************************************************/

USE cpsc321;

-- TODO: add queries with comments below

-- (a)
SELECT c.name, COUNT(*)
FROM film_category fc JOIN category c USING (category_id)
GROUP BY fc.category_id
ORDER BY COUNT(*) DESC
LIMIT 10;


-- (b)
SELECT c.first_name, c.last_name, COUNT(*)
FROM customer c JOIN payment p USING (customer_id)
     JOIN rental r USING (rental_id)
     JOIN inventory i USING (inventory_id)
     JOIN film f USING (film_id)
WHERE f.rating = 'PG' AND p.amount = 2.99
GROUP BY c.customer_id
HAVING COUNT(*) >= 4
ORDER BY COUNT(*) DESC
LIMIT 10;


-- (c)
SELECT f.title, p.amount
FROM film f JOIN inventory i USING (film_id)
     JOIN rental r USING (inventory_id)
     JOIN payment p USING (rental_id)
WHERE f.rating = 'G'
HAVING p.amount >= ALL (SELECT amount
                        FROM payment);


-- (d)
SELECT c.name, COUNT(*)
FROM category c JOIN film_category fc USING (category_id)
     JOIN film f USING (film_id)
WHERE f.rating = 'PG'
GROUP BY c.category_id
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
                        FROM category c JOIN film_category fc USING (category_id)
                             JOIN film f USING (film_id)
                        WHERE f.rating = 'PG'
                        GROUP BY c.category_id);


-- (e)
SELECT f.title, COUNT(*) as num_rentals
FROM film f JOIN inventory i USING (film_id)
     JOIN rental r USING (inventory_id)
WHERE f.rating = 'G'
GROUP BY f.title
HAVING COUNT(*) >= (SELECT AVG(tot_rentals)
                    FROM (SELECT COUNT(*) as tot_rentals 
                          FROM film f JOIN inventory i USING (film_id) 
                               JOIN rental r USING (inventory_id) WHERE f.rating = 'G' 
                          GROUP BY f.title) AS co)
ORDER BY COUNT(*) DESC
LIMIT 10;


-- (f)
(SELECT a.first_name, a.last_name
FROM actor a)
EXCEPT
(SELECT a.first_name, a.last_name
FROM actor a JOIN film_actor fa USING (actor_id)
     JOIN film f USING (film_id)
     WHERE f.rating = 'G'
);


-- (g)
SELECT f.title
FROM film f JOIN inventory i USING (film_id)
GROUP BY f.title
HAVING SUM(DISTINCT i.store_id) = (
     SELECT SUM(DISTINCT s.store_id)
     FROM store s
)
LIMIT 10;


-- (h)
SELECT t.actor_id, t.first_name, t.last_name, g.g_films / t.total_films AS pct
FROM (SELECT a.actor_id, a.first_name, a.last_name, COUNT(*) AS total_films
      FROM film f JOIN film_actor fa USING (film_id)
           JOIN actor a USING (actor_id)
           GROUP BY a.actor_id
     ) AS t
     JOIN (SELECT a2.actor_id, a2.first_name, a2.last_name, COUNT(*) AS g_films
           FROM film f2 JOIN film_actor fa2 USING (film_id)
                JOIN actor a2 USING (actor_id)
           WHERE f2.rating = 'G'
           GROUP BY a2.actor_id
           ) AS g USING (actor_id)
WHERE g.g_films > 0
ORDER BY pct DESC
LIMIT 10;
          

-- (i)
SELECT f.title
FROM film f LEFT OUTER JOIN film_actor fa USING (film_id)
WHERE fa.actor_id IS NULL;


-- (j)
SELECT f.title
FROM film f JOIN inventory i USING (film_id)
     LEFT OUTER JOIN rental r USING (inventory_id)
WHERE r.rental_id IS NULL;


-- (k)
SELECT f.film_id, COUNT(fa.actor_id) AS num_of_actors
FROM film f LEFT OUTER JOIN film_actor fa USING (film_id)
GROUP BY f.film_id
LIMIT 10;