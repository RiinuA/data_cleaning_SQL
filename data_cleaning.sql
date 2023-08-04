/*Cleaning data in SQL Queries*/

SELECT * FROM nashville_housing_data
--------------------------------------------------------------------------------
/*Populate Property Address Data
Looking at the data, there are lot's of NULLs in Property address*/
SELECT * FROM nashville_housing_data
WHERE propertyaddress is null
order by parcelID

/*When investigating, it seems that parcel ID and Property ID are connected, therefore the address can be populated
Using INNER JOIN to connect parcel ID with Property ID*/

SELECT a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress
FROM nashville_housing_data a
JOIN nashville_housing_data b
ON a.parcelid = b.parcelid
AND a.uniqueid <> b.uniqueid
WHERE a.propertyaddress is null

/*Using COALESCE (postgresql doesn't support ISNULL)*/
SELECT a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress,COALESCE(a.propertyaddress, b.propertyaddress) as address
FROM nashville_housing_data a
JOIN nashville_housing_data b
ON a.parcelid = b.parcelid
AND a.uniqueid <> b.uniqueid
WHERE a.propertyaddress is null

/*Let;s update the table*/
UPDATE nashville_housing_data a
SET propertyaddress = COALESCE(a.propertyaddress, b.propertyaddress)
FROM nashville_housing_data b
WHERE a.parcelid = b.parcelid
AND a.uniqueid <> b.uniqueid
AND a.propertyaddress IS NULL;

SELECT * from nashville_housing_data

/*Double check if the table is updated*/
SELECT * FROM nashville_housing_data
WHERE propertyaddress is null

-------------------------------------------------------------------------
/*Let's break the address into individual colums - Address, City, State*/

SELECT propertyaddress 
FROM nashville_housing_data

/*Using substring and character index
Note: CHARINDEX does not work in postgresql, using POSITION instead*/

SELECT
SUBSTRING(propertyaddress, 1, POSITION(',' IN propertyaddress)-1) as Address
		  FROM nashville_housing_data
/*-1 gets rid of the comma*/

SELECT
SUBSTRING(propertyaddress, 1, POSITION(',' IN propertyaddress)-1) as Street,
SUBSTRING(propertyaddress, POSITION(',' IN propertyaddress)+1) AS City
		  FROM nashville_housing_data


/*Let's add the new data to the table!*/
ALTER TABLE nashville_housing_data
ADD Property_Street_name text;
UPDATE nashville_housing_data
SET Property_Street_name = SUBSTRING(propertyaddress, 1, POSITION(',' IN propertyaddress)-1)

ALTER TABLE nashville_housing_data
ADD Property_City_name text;
UPDATE nashville_housing_data
SET Property_City_name = SUBSTRING(propertyaddress, POSITION(',' IN propertyaddress)+1)

SELECT * FROM nashville_housing_data

ALTER TABLE nashville_housing_data
DROP COLUMN City_name
ALTER TABLE nashville_housing_data
DROP COLUMN Street_name

/*Next we are going to look at the Owner address. Instead of substrings, I will use SPLIT_PART 
function to separate street address, city, and state*/
SELECT owneraddress FROm nashville_housing_data

SELECT
SPLIT_PART(owneraddress, ',', 1) AS owner_street_address,
SPLIT_PART(owneraddress, ',', 2) AS owner_city_address,
SPLIT_PART(owneraddress, ',', 3) AS owner_state_address

FROM nashville_housing_data

/*Now let's add these columns to our table!*/

ALTER TABLE nashville_housing_data
ADD owner_Street_name text;
UPDATE nashville_housing_data
SET owner_Street_name = SPLIT_PART(owneraddress, ',', 1)

ALTER TABLE nashville_housing_data
ADD owner_city_name text;
UPDATE nashville_housing_data
SET owner_city_name = SPLIT_PART(owneraddress, ',', 2)

ALTER TABLE nashville_housing_data
ADD owner_state_name text;
UPDATE nashville_housing_data
SET owner_state_name = SPLIT_PART(owneraddress, ',', 3)


/*Let's look at 'soldasvacant' column. There are 4 distinct answers: Yes, No, Y, N. We wat to unify these answers */
SELECT DISTINCT soldasvacant 
FROM nashville_housing_data

/*Checking the count of each answer. Based on this, majority answers are in the format of Yes and No. 
Therefore this is what we want to change to.*/

SELECT DISTINCT soldasvacant, COUNT(soldasvacant)
FROM nashville_housing_data
Group by soldasvacant
ORDER BY 2

/*Using CASE statement to modify the answers*/
SELECT soldasvacant, 
CASE 
	WHEN soldasvacant = 'Y' THEN 'Yes'
	WHEN soldasvacant = 'N' THEN 'No'
	ELSE soldasvacant
	END
FROM nashville_housing_data

/*Updating the table*/

UPDATE nashville_housing_data
SET soldasvacant = 
CASE 
	WHEN soldasvacant = 'Y' THEN 'Yes'
	WHEN soldasvacant = 'N' THEN 'No'
	ELSE soldasvacant
	END

/*Next we are going to remove some duplicates and get rid of unnecessary tables
Using CTE to find duplicate rows*/

WITH row_numCTE AS(
SELECT *, 
	ROW_NUMBER() OVER(
	PARTITION BY parcelid, propertyaddress, saleprice, saledate, legalreference
		ORDER BY uniqueid) row_num

FROM nashville_housing_data
)
SELECT*FROM row_numCTE where row_num > 1

/*Deleting duplicate rows. Note: postgresql doesn't allow deleting in CTE*/
WITH row_numCTE AS (
  SELECT uniqueid, 
    ROW_NUMBER() OVER (
      PARTITION BY parcelid, propertyaddress, saleprice, saledate, legalreference
      ORDER BY uniqueid
    ) row_num
  FROM nashville_housing_data
)
DELETE FROM nashville_housing_data
WHERE uniqueid IN (
  SELECT uniqueid FROM row_numCTE WHERE row_num > 1
);

/*Since we created split address columns earlier, we don't need the old address columns anymore.
Let's delete them!*/

ALTER TABLE nashville_housing_data
DROP COLUMN propertyaddress, 
DROP COLUMN owneraddress

SELECT * FROM nashville_housing_data



