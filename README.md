# Food Inspection Analysis

## Overview
This project performs an in-depth analysis of food inspection data from Dallas and Chicago, utilizing **Azure Data Factory (ADF)** for data integration and **Snowflake** for data storage. The project involves profiling, cleaning, and transforming data before loading it into Snowflake, where it is further processed and analyzed. The main focus is on understanding restaurant inspection scores, violations, and the overall food safety of restaurants in both cities.

## Project Structure
- **Data Profiling**: Analyzing and cleaning the food inspection data for inconsistencies, null values, and denormalized columns.
- **ER Model and DDL Scripts**: Creating logical and physical database models, including Data Definition Language (DDL) scripts for creating staging and dimensional tables.
- **Data Integration**: Using **Azure Data Factory (ADF)** to automate the loading, cleaning, and transformation of data into Snowflake.
- **Data Storage**: Using **Snowflake** to create staging and dimensional tables, followed by a pipeline that integrates the data into fact tables for final analysis.

## Datasets
- **Dallas Food Inspection Data**: Contains inspection records for Dallas restaurants, with key information about inspection scores, violations, and restaurant details.
- **Chicago Food Inspection Data**: Similar data for Chicago, with additional fields like `LICENSE_NUMBER`, `FACILITY_TYPE`, and `RISK`.

## Key Steps in the Project

### Part 1: Data Profiling
- **Dallas Dataset**: The Dallas dataset contains 114 columns with 78,984 records. Columns like `RESTAURANT_NAME`, `INSPECTION_SCORE`, and `STREET_ADDRESS` have no missing values. Data inconsistencies were handled by eliminating unnecessary columns and converting denormalized data into a clean format.
- **Chicago Dataset**: This dataset has fewer inconsistencies, with all data being in a normalized format. However, some fields were dropped for consistency between the two datasets.

### Part 2: ER Model and DDL Scripts
- **Logical and Physical Models**: Developed ER diagrams to represent the relationships between inspections, restaurants, and violations.
- **DDL Scripts**: The project includes DDL scripts for creating staging tables for Dallas and Chicago inspection data, as well as dimensional tables for analysis.

### Part 3: Data Integration and Snowflake
- **Using Azure Data Factory (ADF)**: ADF pipelines were used for data extraction, transformation, and loading (ETL) from the source data into Snowflake. The data integration workflow in ADF ensures that the data is transformed according to the project requirements before being loaded into Snowflake staging tables.
- **Loading into Snowflake**: The project leverages Snowflake to create staging tables for both cities. Once the data is staged, it is processed and transformed into dimensional tables for deeper analysis.
- **Fact Table Integration**: A pipeline loads the transformed data into a fact table, consolidating violation and inspection details from both Dallas and Chicago.

### Merging Dallas and Chicago Datasets
To merge the two datasets, the following steps were taken:
1. **Align Column Names**: Standardized column names between datasets, e.g., `RESTAURANT_NAME` (Dallas) to `DBA_NAME` (Chicago).
2. **Add Unique Columns**: Chicago-specific columns such as `LICENSE_NUMBER`, `FACILITY_TYPE`, and `RISK` were included with `NULL` values allowed for Dallas records.
3. **Standardize Violation Details**: Unified violation descriptions and comments into a single format for analysis.
4. **Unified Schema**: Designed a schema to incorporate fields from both datasets, allowing flexibility for city-specific data, with `NULL` values for non-applicable columns.

## Technologies Used
- **Azure Data Factory (ADF)**: For ETL processes to load, clean, and transform data from Dallas and Chicago into Snowflake.
- **Snowflake**: For data storage and transformation, including staging, dimensional, and fact tables.
- **SQL**: For data analysis and querying.
- **Power BI**: For visualizing and analyzing the inspection data.
- **Python**: For any additional data processing and automation.

## How to Run the Project
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/food-inspection-analysis.git
