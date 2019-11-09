-- Name: GROUP-25 Aishwarya Manicka Ravichandran and Amy Robertson
-- Description: Data Manipulation queries for tourism database

--
-- SELECT query for `travel_location` display
-- 
SELECT travel_location.travelLocation_ID, travel_location.city, travel_location.country, 
	COUNT(bookings.booking_ID) AS '# Bookings', 
    COUNT(tour_guide.tourGuide_ID) AS '# Tour Guides', 
    SUM(number_adults) + SUM(number_children) AS '# Adults + Kids',
    ROUND(AVG(ratings.rating),2) AS 'Average Review'
    FROM travel_location 
LEFT JOIN bookings ON travel_location.travelLocation_ID = bookings.travelLocation_ID
LEFT JOIN assignment ON bookings.booking_ID = assignment.booking_ID
LEFT JOIN tour_guide ON assignment.tourGuide_ID = tour_guide.tourGuide_ID
LEFT JOIN customers ON bookings.customer_ID = customers.customer_ID
LEFT JOIN ratings ON customers.customer_ID = ratings.customer_ID
GROUP BY travel_location.travelLocation_ID
ORDER BY travel_location.travelLocation_ID
--
-- SELECT query for `tour_guide` display
-- 

--
-- SELECT query for `assignments` display
-- 