-- Name: GROUP-25 Aishwarya Manicka Ravichandran and Amy Robertson
-- Description: Data Manipulation queries for tourism database

--
-- SELECT query for `customers` display
--
SELECT customers.customer_ID, customers.first_name, customers.middle_name, customers.last_name, 
		customers.street_no, customers.city, customers.state, customers.country,
		customers.phone_number, customers.email_id, 
		COUNT(bookings.booking_ID) AS '# Bookings',
		COUNT(ratings.rating_ID) AS '# Reviews'
		FROM customers
	LEFT JOIN bookings ON customers.customer_ID = bookings.customer_ID
	LEFT JOIN ratings ON customers.customer_ID = ratings.rating_ID
	GROUP BY customers.customer_ID
	ORDER BY customers.customer_ID;
--
-- Add new customer
--
INSERT INTO customer (first_name, last_name, middle_name, street_no, city, state, country, postal_code, 
			phone_number, email_id, passport_number, passport_countryofissue, passport_expirydate)
			VALUES (:fnameInput, :lnameInput, :mname_Input, street_Input, country_Input, postal_codeInput,
			phone_numberInput, email_idInput, passport_numberInput, passport_countryofissueInput, passport_expirydateInput);
--
-- Search Customer
--
SELECT customers.customer_ID, customers.first_name, customers.middle_name, customers.last_name, 
		customers.street_no, customers.city, customers.state, customers.country,
		customers.phone_number, customers.email_id, 
		COUNT(bookings.booking_ID) AS '# Bookings',
		COUNT(ratings.rating_ID) AS '# Reviews'
		FROM customers
	LEFT JOIN bookings ON customers.customer_ID = bookings.customer_ID
	LEFT JOIN ratings ON customers.customer_ID = ratings.rating_ID
	WHERE customers.email_id = :email_idSearchInput
	GROUP BY customers.customer_ID
	ORDER BY customers.customer_ID;
--
-- Update Customer
--
UPDATE customers
SET first_name = :first_nameInput, last_name = :last_nameInput, street = :streetInput,
	city = :cityInput, state = :stateInput, country = :countryInput, phone_number = :phone_numberInput,
	email_id = :email_idInput
WHERE customer_ID = :corresponding_ID_in_td;
--
-- SELECT query for `bookings` display
--
SELECT bookings.booking_ID, bookings.booking_date, bookings.departure_date, bookings.arrival_date,
		bookings.number_adults, bookings.number_children, bookings.travelLocation_ID,
		bookings.customer_ID FROM bookings
		LEFT JOIN travel_location ON bookings.travelLocation_ID = travel_location.travelLocation_ID
		LEFT JOIN customers ON bookings.customer_ID = customers.customer_ID
		GROUP BY bookings.booking_ID
		ORDER BY bookings.booking_ID;
--
-- Add new booking
--
INSERT INTO bookings(customer_ID, travelLocation_ID, departure_date, arrival_date, number_adults, number_children)
			VALUES(:customer_IDInput, (SELECT travelLocation_ID FROM travel_location WHERE city = :travel_locationInput),
				    :departure_dateInput, :arrival_dateInput, :number_adultsInput, :number_childrenInput);
--
-- Search booking
--
SELECT bookings.booking_ID, bookings.booking_date, bookings.departure_date, bookings.arrival_date,
		bookings.number_adults, bookings.number_children, bookings.travelLocation_ID,
		bookings.customer_ID FROM bookings
		LEFT JOIN travel_location ON bookings.travelLocation_ID = travel_location.travelLocation_ID
		LEFT JOIN customers ON bookings.customer_ID = customers.customer_ID
		WHERE booking_ID = :booking_IDInput OR travelLocation_ID = :travelLocation_IDInput 
				OR departure_date = :departure_dateInput OR arrival_date = :arrival_dateInput  
		GROUP BY bookings.booking_ID
		ORDER BY bookings.booking_ID;
--
-- Update Booking
--
UPDATE bookings
SET travelLocation_ID = (SELECT travel_location.travelLocation_ID from travel_location INNER JOIN bookings ON travel_location.travelLocation_ID = bookings.travelLocation_ID
							WHERE travel_location.city = :travel_locationInput),
	departure_date = :departure_dateInput,
	arrival_date = :arrival_dateInput,
	number_adults = :number_adultsInput,
	number_children = :number_childrenInput
WHERE booking_ID = :corresponding_ID_in_td;
--
-- Delete booking
--
DELETE FROM booking WHERE booking_ID = :corresponding_ID_in_td;
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
ORDER BY travel_location.travelLocation_ID;
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
ORDER BY tour_guide.tourGuide_ID;
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
ORDER BY assignment.tourGuide_travelLocation;
--
-- SELECT query for `ratings` display
--
SELECT ratings.rating_ID, ratings.travelLocation_ID,
		travel_location.city AS 'Travel Location',
		ratings.customer_ID,
		CONCAT(customers.first_name, ' ', customers.last_name) AS 'Customer Name',
		ratings.rating, ratings.review
		FROM ratings
		LEFT JOIN travel_location ON ratings.travelLocation_ID = travel_location.travelLocation_ID
		LEFT JOIN customers ON ratings.customer_ID = customers.customer_ID
		GROUP BY ratings.rating_ID
		ORDER BY ratings.rating_ID;
--
-- Add new Rating
--
INSERT INTO ratings(customer_ID, travelLocation_ID, rating, review)
			VALUES(:customer_IDInput, (SELECT travelLocation_ID FROM travel_location WHERE city = :travel_locationInput),
				 :ratingInput, :reviewInput);
--
-- Search rating
--
SELECT ratings.rating_ID, ratings.travelLocation_ID,
		travel_location.city AS 'Travel Location',
		ratings.customer_ID,
		CONCAT(customers.first_name, ' ', customers.last_name) AS 'Customer Name',
		ratings.rating, ratings.review
		FROM ratings
		LEFT JOIN travel_location ON ratings.travelLocation_ID = travel_location.travelLocation_ID
		LEFT JOIN customers ON ratings.customer_ID = customers.customer_ID
		WHERE rating = :ratingInput AND ratings.travelLocation_ID = (SELECT travel_location.travelLocation_ID from travel_location INNER JOIN ratings 
			ON ratings.travelLocation_ID = travel_location.travelLocation_ID 
			WHERE travel_location.city = :cityInput)
		GROUP BY ratings.rating_ID
		ORDER BY ratings.rating_ID;
--
-- SELECT query for `payment` display
--
SELECT payment.payment_ID, payment.booking_ID, payment.payment_amount, payment.payment_date,
		payment.payment_description FROM payment
		LEFT JOIN bookings ON payment.booking_ID = bookings.booking_ID
		GROUP BY payment.payment_ID
		ORDER BY payment.payment_ID;
--
-- Add new payment
--
INSERT INTO payment(booking_ID, payment_amount, payment_date, payment_description)
			VALUES(:booking_IDInput, 
				SELECT (t.amount_perAdult*b.number_adults) + (t.amount_perChild*b.number_children) 
					* (DATEDIFF(b.arrival_date, b.departure_date)) AS payment_amount FROM bookings b INNER JOIN travel_location t 
					ON b.travelLocation_ID = t.travelLocation_ID
					WHERE booking_ID = :booking_IDInput,
				:payment_dateInput, :payment_descriptionInput);
--
-- Search Payment
--
SELECT payment.payment_ID, payment.booking_ID, payment.payment_amount, payment.payment_date,
		payment.payment_description FROM payment
		LEFT JOIN bookings ON payment.booking_ID = bookings.booking_ID
		WHERE payment.payment_ID = :payment_IDInput OR payment.booking_ID = :booking_IDInput OR payment.payment_date = :payment_dateInput
		GROUP BY payment.payment_ID
		ORDER BY payment.payment_ID;
--
-- Delete Payment
--
DELETE FROM payment WHERE payment_ID = :corresponding_ID_in_td;

					   
-- MULTIPURPOSE Queries

-- Get all city/country pairs to populate travel locations dropdowns
SELECT CONCAT(travel_location.city, ', ', travel_locationcountry) FROM travel_location

-- Get all tour guides names to populate tour guide dropdowns
SELECT CONCAT(tour_guide.first_name, ' ', tour_guide.last_name) FROM tour_guide

-- Get all tour booking #s to populate tour guide dropdowns
SELECT bookings.booking_ID FROM bookings


-- Queries for TRAVEL LOCATION

-- Display all options (null entry)
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

-- Display all options (search with selected city/country)
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
WHERE travel_location.city = :city_input AND travel_location.country = :county_input
GROUP BY travel_location.travelLocation_ID
ORDER BY travel_location.travelLocation_ID

--Add & display new Travel Location data based on form submission
INSERT INTO travel_location (city, country) VALUES (:city_input, :country_input) 
SELECT * FROM travel_location WHERE travel_location.city = :city_input AND travel_location.country = :country_input


-- Queries for TOUR GUIDE

--Display all options
SELECT tour_guide.tourGuide_ID, tour_guide.first_Name, tour_guide.last_name, 
    COUNT(assignment.tourGuide_travelLocation) AS '# Assignments',
    COUNT(travel_location.travelLocation_ID) AS '# Locations'
    FROM tour_guide
LEFT JOIN assignment ON tour_guide.tourGuide_ID = assignment.tourGuide_ID
LEFT JOIN travel_location ON assignment.travelLocation_ID = travel_location.travelLocation_ID
GROUP BY tour_guide.tourGuide_ID
ORDER BY tour_guide.tourGuide_ID

-- Display all options (search with selected city/country)
SELECT tour_guide.tourGuide_ID, tour_guide.first_name, tour_guide.last_name, 
    COUNT(assignment.tourGuide_travelLocation) AS '# Assignments',
    COUNT(travel_location.travelLocation_ID) AS '# Locations'
    FROM tour_guide
	WHERE tour_guide.first_name = :first_input AND tour_guide.last_name = :last_input
LEFT JOIN assignment ON tour_guide.tourGuide_ID = assignment.tourGuide_ID
LEFT JOIN travel_location ON assignment.travelLocation_ID = travel_location.travelLocation_ID
GROUP BY tour_guide.tourGuide_ID
ORDER BY tour_guide.tourGuide_ID

-- get a single character's data for the Update People form
SELECT tour_guideID, first_name, last_name FROM tour_guide WHERE tour_guideID = :tour_guideID_from_browse_form

--Update Tour Guide data based on form submission
UPDATE tour_guide SET first_name = :first_input, last_Name = :last_input WHERE tourGuide_ID = :tour_guideID_from_form

--Add & display new Tour Guide data based on form submission
INSERT INTO tour_guide (first_name, last_name) VALUES (:first_input, :last_input) 
SELECT * FROM tour_guide WHERE tour_guide.first_name = :first_input AND tour_guide.last_name = :last_input


-- Queries for ASSIGNMENTS 

-- Display all options
SELECT assignment.tourGuide_travelLocation AS 'Assignment ID#', assignment.booking_ID AS 'Booking ID#',
CONCAT(tour_guide.first_name, ' ', tour_guide.last_name) AS 'Guide',
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

-- Display all options (search with input)
SELECT assignment.tourGuide_travelLocation AS 'Assignment ID#', assignment.booking_ID AS 'Booking ID#',
CONCAT(tour_guide.first_name, ' ', tour_guide.last_name) AS 'Guide',
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
WHERE assignment.booking_ID = :bookingID_input 
	AND assignment.travelLocation_ID = :locationID_input 
	AND assignment.guide = :tour_guideID_input
GROUP BY assignment.tourGuide_travelLocation
ORDER BY assignment.tourGuide_travelLocation

--Add & display new assignment data based on form submission
INSERT INTO assignments () VALUES (:first_input, :last_input) 
SELECT * FROM tour_guide WHERE tour_guide.first_name = :first_input AND tour_guide.last_name = :last_input
