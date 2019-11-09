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
SELECT tour_guide.tourGuide_ID, tour_guide.first_Name, tour_guide.last_Name, 
    COUNT(assignment.tourGuide_travelLocation) AS '# Assignments',
    COUNT(travel_location.travelLocation_ID) AS '# Locations'
    FROM tour_guide
LEFT JOIN assignment ON tour_guide.tourGuide_ID = assignment.tourGuide_ID
LEFT JOIN travel_location ON assignment.travelLocation_ID = travel_location.travelLocation_ID
GROUP BY tour_guide.tourGuide_ID
ORDER BY tour_guide.tourGuide_ID
--
-- SELECT query for `assignments` display
-- 
SELECT assignment.tourGuide_travelLocation AS 'Assignment ID#', assignment.booking_ID AS 'Booking ID#',
CONCAT(tour_guide.first_Name, ' ', tour_guide.last_Name) AS 'Guide',
CONCAT(travel_location.city, ', ', travel_location.country) AS 'Destination',
CONCAT(customers.first_name, ' ', customers.last_name) AS 'Customer Name',
bookings.departure_date AS 'Departure Date',
bookings.arrival_date AS 'Arrival Date',
SUM(bookings.number_adults) AS '# Adults',
SUM(bookings.number_children) AS '# Kids'
    FROM assignment
LEFT JOIN tour_guide ON assignment.tourGuide_ID = tour_guide.tourGuide_ID
LEFT JOIN travel_location ON assignment.travelLocation_ID = travel_location.travelLocation_ID
LEFT JOIN bookings ON assignment.booking_ID = bookings.booking_ID
LEFT JOIN customers ON bookings.customer_ID = customers.customer_ID
GROUP BY assignment.tourGuide_travelLocation
ORDER BY assignment.tourGuide_travelLocation