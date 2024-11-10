## Motor Vehicle Collisions and Weather Data Analysis

### Project Overview

This project focuses on the design and implementation of a data warehouse for analyzing vehicle collision data in conjunction with weather conditions. The goal is to create a robust ETL (Extract, Transform, Load) process and a dimensional model that facilitates insightful analysis of the relationship between weather and vehicle collisions.

### Project Description

The project involves the integration of vehicle collision data and weather data to analyze how weather conditions affect the frequency and severity of vehicle collisions. A star schema is employed to simplify the data structure, allowing for efficient querying and analysis.

### Data Sources

The data for this project is sourced from:

- Vehicle collision datasets

- Weather condition datasets

These datasets were cleaned and transformed to ensure consistency and usability for analysis.

### Dimensional Model
The dimensional model is designed using a star schema, which includes:

- Dimension Tables:

- DimWeather: Contains weather-related attributes such as temperature, humidity, and visibility.

- DimVehicleType: Contains information about different types of vehicles involved in collisions.

- DimLocation: Contains geographical data related to collision locations, including boroughs and street names.

- DimCrashDate: Contains date-related attributes for the crash incidents, facilitating time-based analysis.

- DimCrashTime: Contains time-related attributes for the crash incidents, allowing for analysis based on specific times of day.

- Fact Table:


- FactCollision: Aggregates data from the dimension tables, including measures such as the total number of injured persons, fatalities, and weather conditions at the time of the collision.
![image](https://github.com/user-attachments/assets/accf7afa-04c3-414c-9646-3aebe792ea89)
