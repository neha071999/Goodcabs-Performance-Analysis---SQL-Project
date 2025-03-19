# Goodcabs Performance Analysis - SQL Project

## 📌 Project Overview
This project analyzes the performance of Goodcabs, a ride-hailing service operating in tier-2 cities, using SQL. It evaluates key business metrics such as trip volume, passenger behavior, revenue growth, and performance against company targets. The analysis provides data-driven insights and recommendations to optimize operations and improve customer satisfaction.<br />

## 🏛 Database Schema
The project utilizes two databases:<br />

**trips_db** (Trip & Passenger Data)<br />
*dim_city* - City details (city_id, city_name)<br />
*dim_date* - Date attributes (date, month_name, day_type)<br />
*fact_passenger_summary* - Aggregated passenger data (total, new, repeat passengers)<br />
*dim_repeat_trip_distribution* - Repeat trip breakdown by frequency<br />
*fact_trips* - Detailed trip-level data (trip_id, distance, fare, passenger/driver ratings)<br />

**targets_db** (Performance Targets)<br />
*city_target_passenger_rating* - Target passenger ratings by city<br />
*monthly_target_new_passengers* - Target for new passengers per city<br />
*monthly_target_trips* - Trip count targets per city<br />

## 🔍 Key Insights
**1. Trip Growth Trends**: Identified fluctuations in trip volume across cities and months.<br />
**2. Repeat Passenger Analysis**: Found high retention in key cities with strategic opportunities to increase loyalty.<br />
**3. Revenue & Fare Trends**: Evaluated fare structures and revenue growth.<br />
**4. Passenger Ratings**: Compared actual vs. target ratings for service quality assessment.<br />
**5. Performance Against Targets**: Assessed achievement of trip and new passenger goals.<br />

## 📝 SQL Queries & Analysis
The analysis includes:<br />
**1.** Aggregated monthly trip counts and revenue<br />
**2.** City-wise passenger segmentation<br />
**3.** Repeat trip frequency trends<br />
**4.** Passenger rating distributions and deviations from targets<br />
**5.** Trip volume vs. target comparisons<br />

## 📊 Visualizations & Dashboards
The project includes graphical representations such as:<br />
**1.** Monthly trip volume trends<br />
**2.** Passenger retention rate visualization<br />
**3.** Revenue growth charts<br />
**4.** City-wise performance comparisons<br />

## 📌 Recommendations
Based on the findings, the following actions are suggested:<br />
**1.** Increase Retention Strategies: Offer incentives for repeat passengers in low-loyalty cities.<br />
**2.** Optimize Fare Structures: Adjust pricing in cities with revenue decline.<br />
**3.** Enhance Driver-Passenger Experience: Improve training and engagement to boost ratings.<br />
**4.** Expand in High-Growth Cities: Focus marketing efforts where demand is rising.<br />

## 📌 Project Files
**Goodcabs Performance Analysis** - [SQL scripts for analysis](https://github.com/neha071999/Goodcabs-Performance-Analysis---SQL-Project/blob/main/Goodcabs%20Performance%20Analysis.sql)<br />
**Goodcabs Performance Analysis - SQL Project** - [Report with insights and visualizations](https://github.com/neha071999/Goodcabs-Performance-Analysis---SQL-Project/blob/main/Goodcabs%20Performance%20Analysis%20-%20SQL%20%20Project.pdf)<br />
**Database Schemas** - [Database Schemas details for tables](https://github.com/neha071999/Goodcabs-Performance-Analysis---SQL-Project/blob/main/database_schemas.zip)<br />

### Thank You!
