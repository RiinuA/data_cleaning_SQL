# Nashville Housing Data Cleaning in SQL #
This repository contains SQL queries used to clean the nashville_housing_data dataset. The cleaning process involves handling missing values, splitting address columns, standardizing entries, and removing duplicates.

## Data Source ##
The data used in this project is from the nashville_housing_data dataset. This dataset contains information about various properties in Nashville, including their addresses, sale prices, sale dates, and other relevant details.

## Cleaning Process ##
The cleaning process involves several steps:
#### Handling Missing Values: ####
The propertyaddress column has many NULL values. These are filled using the associated parcelId.

#### Splitting Address Columns: ####
The propertyaddress and owneraddress columns are split into separate columns for street, city, and state.

#### Standardizing Entries: ####
The soldasvacant column has inconsistent entries. These are standardized to 'Yes' and 'No'.

#### Removing Duplicates: ###
Duplicate rows are identified and removed based on specific columns.

##### The cleaning process uses several SQL commands and functions, including JOIN, SUBSTRING, SPLIT_PART, COALESCE, and the CASE statement. ####

## Queries ##
The SQL queries used for the cleaning process can be found in the data_cleaning.sql file in this repository. These queries perform the cleaning tasks mentioned above and include some exploratory queries to understand the data better.

## Results ##
The result of this cleaning process is a cleaned version of the nashville_housing_data dataset. This cleaned dataset is more suitable for further analysis. It has no missing values in the propertyaddress column, separate columns for different parts of the addresses, standardized entries in the soldasvacant column, and no duplicate rows.

### Contributing ###
Contributions to this project are welcome! If you have a suggestion for improving the cleaning process or the SQL queries, please open an issue to discuss it. If you want to contribute directly, feel free to make a pull request.
