/*                   Key Metrics                 */

-- 1. Total trips -- 
SELECT CONCAT(ROUND(COUNT(*) / 1000, 0), 'K') AS total_trips
FROM fact_trips;

-- 2. Total Fare (Revenue) --
SELECT CONCAT(ROUND(SUM(fare_amount) / 1000000, 0), 'M') AS total_revenue
FROM fact_trips;

-- 3. Total Distance Travelled
SELECT CONCAT(ROUND(SUM(distance_travelled_km) / 1000000, 1), 'M km') AS total_distance_travelled
FROM fact_trips;

-- 4. a) Average Passenger Rating
SELECT AVG(passenger_rating) AS avg_passenger_rating
FROM fact_trips;

--    b) Average Driver Rating
SELECT AVG(driver_rating) AS avg_driver_rating
FROM fact_trips;

-- 5. Average Fare per Trip (Average Trip Cost)
SELECT AVG(fare_amount) AS avg_fare_per_trip
FROM fact_trips;

-- 6. Average Fare per km (Average km Cost)
SELECT SUM(fare_amount) / NULLIF(SUM(distance_travelled_km), 0) AS avg_fare_per_km
FROM fact_trips;

-- 7. Average Trip Distance
SELECT CONCAT(ROUND(AVG(distance_travelled_km), 2), 'km') AS avg_trip_distance
FROM fact_trips;

-- 8. Trip Distance (Max, Min) 
SELECT 
    CONCAT(MAX(distance_travelled_km), ' km') AS max_trip_distance,
    CONCAT(MIN(distance_travelled_km), ' km') AS min_trip_distance
FROM fact_trips;

-- 9. a) Trip Type: New Trips
SELECT ROUND(COUNT(*)/ 1000, 0) AS new_trips
FROM fact_trips
WHERE passenger_type = 'new';

--    b) a) Trip Type: Repeated Trips
SELECT ROUND(COUNT(*)/ 1000, 0) AS repeated_trips
FROM fact_trips
WHERE passenger_type = 'repeated';

-- 10. Total Passengers
SELECT SUM(total_passengers) AS total_passengers
FROM fact_passenger_summary;

-- 11. New passengers
SELECT ROUND(SUM(new_passengers) / 1000, 0) AS total_new_passengers
FROM fact_passenger_summary;

-- 12. Repeated Passengers
SELECT ROUND(SUM(repeat_passengers) / 1000, 0) AS total_repeat_passengers
FROM fact_passenger_summary;

-- 13. Repeat Passenger Rate(%)
SELECT 
    (SUM(repeat_passengers) * 100.0 / NULLIF(SUM(total_passengers), 0)) AS repeat_passenger_rate
FROM fact_passenger_summary;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*                   Business Problems & SQL Analysis                 */

-- Q1. Identify the top 3 and bottom 3 cities by total trips over the entire analysis period.

(
    SELECT c.city_name, COUNT(f.trip_id) AS total_trips
    FROM fact_trips f
    JOIN dim_city c ON f.city_id = c.city_id
    GROUP BY c.city_name
    ORDER BY total_trips DESC
    LIMIT 3  -- Top 3 Cities
)
UNION ALL
(
    SELECT c.city_name, COUNT(f.trip_id) AS total_trips
    FROM fact_trips f
    JOIN dim_city c ON f.city_id = c.city_id
    GROUP BY c.city_name
    ORDER BY total_trips ASC
    LIMIT 3  -- Bottom 3 Cities
);

-- Q2. Calculate the Average fare per trip by each city and compare it with the city’s  average trip distance. Identify the cities with the highest and lowest average fare per trip to assess pricing efficiency across locations.

SELECT 
    dc.city_name, 
    AVG(ft.fare_amount) AS avg_fare_per_trip, 
    AVG(ft.distance_travelled) AS avg_trip_distance 
FROM fact_trips ft
JOIN dim_city dc ON ft.city_id = dc.city_id
GROUP BY dc.city_name
ORDER BY avg_fare_per_trip DESC;

-- Q3. (i) Calculate the Average passenger and driver ratings for each city, segmented by passenger type.

SELECT 
    ft.city_id,
    dc.city_name,
    ft.passenger_type,
    ROUND(AVG(ft.passenger_rating), 2) AS avg_passenger_rating,
    ROUND(AVG(ft.driver_rating), 2) AS avg_driver_rating
FROM fact_trips ft
JOIN dim_city dc ON ft.city_id = dc.city_id
GROUP BY ft.city_id, dc.city_name, ft.passenger_type
ORDER BY avg_passenger_rating DESC;

--     (ii) Identify cities with the highest and lowest average ratings.

SELECT 'Highest' AS category, city_name, avg_passenger_rating 
FROM (
    SELECT 
        dc.city_name,
        ROUND(AVG(ft.passenger_rating), 2) AS avg_passenger_rating
    FROM fact_trips ft
    JOIN dim_city dc ON ft.city_id = dc.city_id
    GROUP BY dc.city_name
    ORDER BY avg_passenger_rating DESC 
    LIMIT 1
) highest

UNION ALL

SELECT 'Lowest' AS category, city_name, avg_passenger_rating 
FROM (
    SELECT 
        dc.city_name,
        ROUND(AVG(ft.passenger_rating), 2) AS avg_passenger_rating
    FROM fact_trips ft
    JOIN dim_city dc ON ft.city_id = dc.city_id
    GROUP BY dc.city_name
    ORDER BY avg_passenger_rating ASC 
    LIMIT 1
) lowest;

-- Q4. For each city, Identify the month with the highest total trips (peak demand) and the month with the lowest total trips (low demand). This analysis will help Goodcabs understand seasonal patterns and adjust resources accordingly. 

SELECT 
    city_id,
    city_name,
    MAX(CASE WHEN peak_rank = 1 THEN month END) AS peak_month,
    MAX(CASE WHEN peak_rank = 1 THEN total_trips END) AS high_total_trips,
    MAX(CASE WHEN low_rank = 1 THEN total_trips END) AS low_total_trips
FROM (
    SELECT 
        ft.city_id,
        dc.city_name,
        DATE_FORMAT(ft.trip_date, '%M') AS month, -- Extracts only the month name
        COUNT(ft.trip_id) AS total_trips,
        RANK() OVER (PARTITION BY ft.city_id ORDER BY COUNT(ft.trip_id) DESC) AS peak_rank,
        RANK() OVER (PARTITION BY ft.city_id ORDER BY COUNT(ft.trip_id) ASC) AS low_rank
    FROM fact_trips ft
    JOIN dim_city dc ON ft.city_id = dc.city_id
    GROUP BY ft.city_id, dc.city_name, month
) ranked_data
WHERE peak_rank = 1 OR low_rank = 1
GROUP BY city_id, city_name
ORDER BY city_id;

-- Q5. Compare the total trips taken on weekdays versus weekends for each city over the six-month period. Identify cities with a strong preference for either weekend or weekday trips to understand demand variations.

SELECT 
    dc.city_id,
    dc.city_name,
    SUM(CASE WHEN dd.day_type = 'Weekend' THEN 1 ELSE 0 END) AS weekend_trips,
    SUM(CASE WHEN dd.day_type = 'Weekday' THEN 1 ELSE 0 END) AS weekday_trips,
    CASE 
        WHEN SUM(CASE WHEN dd.day_type = 'Weekend' THEN 1 ELSE 0 END) 
             > SUM(CASE WHEN dd.day_type = 'Weekday' THEN 1 ELSE 0 END) 
        THEN 'Weekend Preference'
        ELSE 'Weekday Preference'
    END AS preference
FROM fact_trips ft
JOIN dim_date dd ON ft.date = dd.date
JOIN dim_city dc ON ft.city_id = dc.city_id
GROUP BY dc.city_id, dc.city_name
ORDER BY (weekend_trips + weekday_trips) DESC;

-- Q6. Analyse the frequency of trips taken by repeat passengers in each city.  Identify which cities contribute most to higher trip frequencies among repeat passengers, and examine if there are distinguishable patterns between tourism-focused and business-focused cities.

SELECT 
    d.city_id,
    c.city_name,
    SUM(CASE WHEN d.trip_count = 10 THEN d.repeat_passenger_count ELSE 0 END) AS "10_trip_count",
    SUM(CASE WHEN d.trip_count = 9 THEN d.repeat_passenger_count ELSE 0 END) AS "9_trip_count",
    SUM(CASE WHEN d.trip_count = 8 THEN d.repeat_passenger_count ELSE 0 END) AS "8_trip_count",
    SUM(CASE WHEN d.trip_count = 7 THEN d.repeat_passenger_count ELSE 0 END) AS "7_trip_count",
    SUM(CASE WHEN d.trip_count = 6 THEN d.repeat_passenger_count ELSE 0 END) AS "6_trip_count",
    SUM(CASE WHEN d.trip_count = 5 THEN d.repeat_passenger_count ELSE 0 END) AS "5_trip_count",
    SUM(CASE WHEN d.trip_count = 4 THEN d.repeat_passenger_count ELSE 0 END) AS "4_trip_count",
    SUM(CASE WHEN d.trip_count = 3 THEN d.repeat_passenger_count ELSE 0 END) AS "3_trip_count",
    SUM(CASE WHEN d.trip_count = 2 THEN d.repeat_passenger_count ELSE 0 END) AS "2_trip_count",
    SUM(d.repeat_passenger_count) AS repeat_passenger_count,
    SUM(d.repeat_passenger_count) AS total_repeat_passengers,
    ROUND((SUM(d.repeat_passenger_count) * 100.0) / NULLIF(SUM(d.repeat_passenger_count), 0), 2) AS repeat_percentage
FROM 
    dim_repeat_trip_distribution d
JOIN 
    dim_city c ON d.city_id = c.city_id
GROUP BY 
    d.city_id, c.city_name
ORDER BY 
    d.city_id;


/*            It's Done, Thank You :)             */
