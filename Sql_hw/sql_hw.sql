use sakila;
select * from actor;
-- 1a. Display the first and last names of all actors from the table actor

select first_name, last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

select concat(first_name,' ', last_name) AS actor_name from actor;
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name from actor where first_name like 'Joe%';
-- 2b. Find all actors whose last name contain the letters GEN:
select actor_id, first_name, last_name from actor where last_name like '%gen%';
-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select actor_id, first_name, last_name from actor where last_name like '%li%' order by 3,1;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country from country where country in ('Afghanistan', 'Bangladesh','China');

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
ALTER TABLE actor 
ADD COLUMN middle_name TEXT AFTER first_name;

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
ALTER TABLE actor MODIFY COLUMN middle_name blob;

-- 3c. Now delete the middle_name column.
ALTER TABLE actor
  DROP COLUMN middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name,COUNT(*) as last_name_count FROM actor GROUP BY last_name ORDER BY 1;
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name,COUNT(*) as last_name_count FROM actor GROUP BY last_name HAVING last_name_count > 1 ;
-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
select * from actor where first_name = 'groucho' and last_name = 'williams';
select * from actor where actor_id = '172';
start transaction;
update actor
set first_name = 'HARPO' where actor_id = '172';
commit;

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. 
-- Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. 
-- BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
start transaction;
update actor
set first_name = 'GROUCHO' where first_name = 'HARPO';
commit;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

 SHOW CREATE TABLE address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select * from address;
select * from staff;

select first_name, last_name, address from address join staff on address.address_id = staff.address_id;
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select * from staff;
select * from payment;
select sum(amount), staff.staff_id, first_name, last_name from payment join staff on payment.staff_id = staff.staff_id group by 2;
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select * from film_actor;
select * from film;
select * from film_actor where film_id = 1;
select film.film_id, title, count(actor_id) from film inner join film_actor on film.film_id = film_actor.film_id group by 1;
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select * from inventory;
select * from film;
select count(inventory.film_id), title, film.film_id from inventory join film on inventory.film_id = film.film_id where title = 'Hunchback Impossible';
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select * from payment;
select * from customer;
select sum(amount), customer.customer_id, last_name, first_name from payment join customer on payment.customer_id = customer.customer_id group by 3;
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
-- films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select * from film;
select * from language;
select * from film where title like 'K%' or 'Q%' and language_id = '1';

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select * from actor;
select * from film;
select * from film_actor;
SELECT first_name, last_name
 FROM actor
 where actor_id in (
 select actor_id 
 from film_actor
 where film_id in(
 select film_id from
 film where title = 'Alone Trip'));

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers.
 -- Use joins to retrieve this information.
select * from customer;
select * from address;
select * from city;
select * from country;
select * 
from customer c
join address a
on c.address_id = a. address_id
join city k
on a.city_id = k.city_id
join country d
on k.country_id = d.country_id
where country = 'Canada'

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
select * from  film;
select * from film_category;
select * from  category;
select * 
from film a
join film_category b
on a.film_id = b.film_id
join category c on c.category_id = b.category_id
where c.name = 'Family';
-- 7e. Display the most frequently rented movies in descending order.
select count(rental_id), title 
from rental r
join inventory i on
r.inventory_id = i.inventory_id
join film f
on f.film_id = i.film_id
group by 2
order by 1 desc;
-- 7f. Write a query to display how much business, in dollars, each store brought in.
select * from payment;
select * from rental;
select * from staff;
select * from store;
select sum(p.amount), z.store_id
from payment p
join rental r
on p.staff_id = r.staff_id
join staff s 
on s.staff_id = r.staff_id
join store z
on s.store_id = z.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.

select store_id, city, country
from store s 
join address a
on s.address_id = a.address_id
join city c
on a.city_id = c.city_id
join country k
on c.country_id = k.country_id;

-- 7h. List the top five genres in gross revenue in descending order.
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select sum(amount), name 
from category c
join film_category f
on c.category_id = f.category_id
join inventory i
on f.film_id = i.film_id
join rental r
on i.inventory_id = r.inventory_id
join payment p
on p.rental_id = r.rental_id
group by 2
order by 2
limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW genres AS select sum(amount), name 
from category c
join film_category f
on c.category_id = f.category_id
join inventory i
on f.film_id = i.film_id
join rental r
on i.inventory_id = r.inventory_id
join payment p
on p.rental_id = r.rental_id
group by 2
order by 2
limit 5;
-- 8b. How would you display the view that you created in 8a?

select * from genres;
-- v8c. You find that you no longer need the view top_five_genres. Write a query to delete it
DROP VIEW genres
