/*Q1: Who is the senior most employee based on job title? */

select * from employee
order by levels desc
limit 1


/*Q2: Which countries have the most Invoices? */
SELECT COUNT(*) AS c, billing_country 
FROM invoice
GROUP BY billing_country
ORDER BY c DESC


/*Q3:- What are top 3 values of the total invoice? */

select total
from invoice 
order by total desc
limit 3


/*Q4:- Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money.
Write a query that returns one city that has the highest sum of invoice totals. Return both the city name and sum of all invoice totals  */
select sum(total) as invoice_total,billing_city
from invoice
group by billing_city
order by invoice_total desc



