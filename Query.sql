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




