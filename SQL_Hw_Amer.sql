Use sakila;

Show tables;


/* 1a. Display the first and last names of all actors from the table `actor`. 
   1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`. 
*/
Select 
  actor.first_name,
  actor.last_name
from actor
;
  
ALTER TABLE actor ADD Actor_Name VARCHAR(30); 
UPDATE actor SET actor_name = CONCAT(first_name, ' ', last_name); 

Select actor.actor_name
from actor;

/* 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
   2b. Find all actors whose last name contain the letters `GEN`:
   2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
   2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
*/
Select actor.actor_id, actor.first_name, actor.last_name
from actor
Where first_name='Joe';

Select actor.actor_id, actor.first_name, actor.last_name
from actor
where last_name like '%GEN%';

Select actor.actor_id, actor.first_name, actor.last_name
from actor
where last_name like '%LI%'
order by Last_name, first_name;

Select  country.country_id
from country 
where country in ('Afghanistan', 'Bangladesh', 'China');


/* 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.
   3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.
   3c. Now delete the `middle_name` column.
*/

Alter Table actor 
  Add middle_name VARCHAR(30); 

Update actor 
  Set middle_name = 'blobs'; 

Alter table actor 
  drop column middle_name;


/* 4a. List the last names of actors, as well as how many actors have that last name.
   4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
   4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, 
       the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
   4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! 
       In a single query, if the first name of the actor is currently `HARPO`, 
       change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, 
       as that is exactly what the actor will be with the grievous error. 
       BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, 
       HOWEVER! (Hint: update the record using a unique identifier.)
*/
SELECT actor.last_name, COUNT(actor.last_name)
	FROM actor
    GROUP BY last_name;

/* 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it? */
/* I would fo to Server, Data import, and import the schema from sef contained file*/

/*6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
  6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. 
  6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
  6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
  6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
*/
SELECT last_name, first_name, address
FROM staff
INNER JOIN address
ON staff.address_id=address.address_id;

SELECT amount, payment_date, staff_id
FROM payment
INNER JOIN staff
ON payment.staff_id=staff.staff_id and payment_date like '2005-08%';



/* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
       As an unintended consequence, films starting with the letters `K` and `Q` 
	   have also soared in popularity. Use subqueries to display the titles of movies 
       starting with the letters `K` and `Q` whose language is English. 
   */

SELECT *
FROM film
WHERE title in ('Q%' or 'K%' );

/* 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
   */
CREATE VIEW T AS (
  SELECT i.first_name,i.last_name,i.actor_id, p.film_id FROM
    actor i
  LEFT JOIN 
    film_actor p 
  ON
    i.actor_id=p.actor_id
  LEFT JOIN
    film f
  ON 
    p.film_id=f.film_id
  WHERE 
    f.title= 'Alone Trip'
);

/* 7c. You want to run an email marketing campaign in Canada, 
       for which you will need the names and email addresses of all Canadian customers. 
       Use joins to retrieve this information.
   */
   
CREATE VIEW S AS (
  SELECT c.first_name,c.last_name,c.email, a.address_id, b.customer_id FROM
    customer c
  LEFT JOIN 
    address a 
  ON
    c.address_id=a.address_id
  LEFT JOIN
    country b
  ON 
    a.customer_id=b.customer_id
  WHERE 
    b.country= 'Canada'
);

/*7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
      Identify all movies categorized as famiy films.
  */
  
SELECT *
  FROM film_category
  INNER JOIN film
  ON film_category.film_id = film.film_id and film_category= 'Family';
  
/* 7e. Display the most frequently rented movies in descending order.    */
SELECt title, count(*) as frequency
FROM film
GROUP BY film_id
ORDER BY count(*) desc;

/* 7f. Write a query to display how much business, in dollars, each store brought in.    */
SELECT amount, SUM(amount) AS total_amount
FROM payment
GROUP BY store.store_id;
   


   /*7g. Write a query to display for each store its store ID, city, and country.
  */
SELECT country_id
from country
inner join city
where
	(SELECT city_id
	from address
	inner join city
	where
		(SELECT store_id
		FROM store
		INNER JOIN address
		WHERE Store.address_id = address.address_id)
		)
    );
  /*  7h. List the top five genres in gross revenue in descending order. 
  (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
*/



/* 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
   8b. How would you display the view that you created in 8a?
   8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
*/

