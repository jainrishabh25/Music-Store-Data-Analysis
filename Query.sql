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
Write a query that returns one city that has the highest sum of invoice totals.
Return both the city name and sum of all invoice totals  */
select sum(total) as invoice_total,billing_city
from invoice
group by billing_city
order by invoice_total desc

/*Q5:-Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the most money*/
select customer.customer_id,customer.first_name,customer.last_name ,sum(invoice.total) as total
from customer
join invoice on customer.customer_id=invoice.customer_id
group by customer.customer_id
order by total desc
limit 1


/* Question Set 2 - Moderate */

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

/*Method 1 */

select distinct email, first_name, last_name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in (
select track_id from track
join genre on track.genre_id = genre.genre_id
where genre.name like 'Rock'
)
order by email;

/*Method 2 */
select distinct email as email, first_name as firstname, last_name as lastname, genre.name as Name
from customer
join invoice on invoice.customer_id = customer.customer_id
join invoiceline on invoiceline.invoice_id = invoice.invoice_id
join track on track.track_id = invoiceline.track_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
order by email;

/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'ROck'
group by artist.artist_id
order by number_of_songs desc
limit 10;

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

select name, miliseconds
from track
where miliseconds > (
    select avg(miliseconds) as avg_track_length
    from track
)
order by miliseconds desc;

/* Question Set 3 - Advance */

/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

/* Steps to Solve: First, find which artist has earned the most according to the InvoiceLines. Now use this artist to find 
which customer spent the most on this artist. For this query, you will need to use the Invoice, InvoiceLine, Track, Customer, 
Album, and Artist tables. Note, this one is tricky because the Total spent in the Invoice table might not be on a single product, 
so you need to use the InvoiceLine table to find out how many of each product was purchased, and then multiply this by the price
for each artist. */

/* Q2: Most popular music genre for each country */

/* Method 1: Using CTE */

with popular_genre as 
(
    select count(invoice_line.quantity) as purchases, customer.country, genre.name, genre.genre_id, 
    row_number() over(partition by customer.country order by count(invoice_line.quantity) desc) as rowno 
    from invoice_line 
    join invoice on invoice.invoice_id = invoice_line.invoice_id
    join customer on customer.customer_id = invoice.customer_id
    join track on track.track_id = invoice_line.track_id
    join genre on genre.genre_id = track.genre_id
    group by 2,3,4
    order by 2 asc, 1 desc
)
select * from popular_genre where rowno <= 1;


/* Method 2: Using Recursive */

with recursive
    sales_per_country as(
        select count(*) as purchases_per_genre, customer.country, genre.name, genre.genre_id
        from invoice_line
        join invoice on invoice.invoice_id = invoice_line.invoice_id
        join customer on customer.customer_id = invoice.customer_id
        join track on track.track_id = invoice_line.track_id
        join genre on genre.genre_id = track.genre_id
        group by 2,3,4
        order by 2
    ),
    max_genre_per_country as (select max(purchases_per_genre) as max_genre_number, country
        from sales_per_country
        group by 2
        order by 2)

select sales_per_country.* 
from sales_per_country
join max_genre_per_country on sales_per_country.country = max_genre_per_country.country
where sales_per_country.purchases_per_genre = max_genre_per_country.max_genre_number;


/* Q3: Customer that has spent the most on music for each country */

/* Method 1: using CTE */

with customter_with_country as (
        select customer.customer_id,first_name,last_name,billing_country,sum(total) as total_spending,
        row_number() over(partition by billing_country order by sum(total) desc) as rowno 
        from invoice
        join customer on customer.customer_id = invoice.customer_id
        group by 1,2,3,4
        order by 4 asc,5 desc
)
select * from customter_with_country where rowno <= 1;


/* Method 2: Using Recursive */

with recursive 
    customter_with_country as (
        select customer.customer_id,first_name,last_name,billing_country,sum(total) as total_spending
        from invoice
        join customer on customer.customer_id = invoice.customer_id
        group by 1,2,3,4
        order by 2,3 desc
    ),
    country_max_spending as(
        select billing_country,max(total_spending) as max_spending
        from customter_with_country
        group by billing_country
    )

select cc.billing_country, cc.total_spending, cc.first_name, cc.last_name, cc.customer_id
from customter_with_country cc
join country_max_spending ms
on cc.billing_country = ms.billing_country
where cc.total_spending = ms.max_spending
order by 1;

/* Thank You :) */




