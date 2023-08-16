-- Write the SQL queries to answer the following questions:

-- Select the first name, last name, and email address of all the customers who have rented a movie.

SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON f.film_id = i.film_id;

-- What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, AVG(p.amount) AS average_payment
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, customer_name;

-- Select the name and email address of all the customers who have rented the "Action" movies.

-- Write the query using multiple join statements

SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
WHERE cat.name = 'Action';

-- Write the query using sub queries with multiple WHERE clause and IN condition

SELECT first_name, last_name, email
FROM customer
WHERE customer_id IN (
    SELECT DISTINCT r.customer_id
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    WHERE f.film_id IN (
        SELECT fc.film_id
        FROM film_category fc
        JOIN category cat ON fc.category_id = cat.category_id
        WHERE cat.name = 'Action'
    )
);

-- Verify if the above two queries produce the same results or not

-- no, the result is not the same as in the second query the results will contain the names of customers that have rented a film that is under the category "Action" but it might be under another category as well.

-- Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
-- If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.

SELECT 
    c.first_name,
    c.last_name,
    c.email,
    p.amount,
    CASE
        WHEN p.amount BETWEEN 0 AND 2 THEN 'low'
        WHEN p.amount BETWEEN 2 AND 4 THEN 'medium'
        ELSE 'high'
    END AS payment_label
FROM 
    customer c
JOIN 
    payment p ON c.customer_id = p.customer_id
WHERE 
    c.customer_id IN (
        SELECT DISTINCT r.customer_id
        FROM rental r
        JOIN inventory i ON r.inventory_id = i.inventory_id
        JOIN film f ON i.film_id = f.film_id
        WHERE f.film_id IN (
            SELECT fc.film_id
            FROM film_category fc
            JOIN category cat ON fc.category_id = cat.category_id
            WHERE cat.name = 'Action'
        )
    );