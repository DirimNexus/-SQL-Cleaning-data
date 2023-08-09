/*


CLEANING DATA IN SQL QUERIES

SKILLS USED: SubString, CharacterIndex, ParseName, Case Statement, Replace function, CTE,
Windows Function, Update,Remove Duplicate, Delete, Alter table, Drop column.

*/


SELECT *
FROM [Nashville-housing]

-------------------------------------------------------------------------------------------
---Standardize Date Format.
-------------------------------------------------------------------------------------------

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM [Nashville-housing]

UPDATE [Nashville-housing]
SET SaleDate = CONVERT(Date,SaleDate)

--If it doesn't work properly.

ALTER TABLE [Nashville-housing]
ADD SaleDateConverted Date;

UPDATE [Nashville-housing]
SET SaleDateConverted = CONVERT(Date,SaleDate)


--------------------------------------------------------------------------------
--Populate Property Address data
--------------------------------------------------------------------------------

SELECT *
FROM [Nashville-housing]
ORDER BY ParcelID

SELECT a.ParcelID, a.propertyAddress, b.ParcelID, b.propertyAddress
FROM [Nashville-housing] a
JOIN [Nashville-housing] b
ON a.ParcelID =b.ParcelID
AND a.[UniqueID ] = b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL (a.propertyAddress,b.propertyAddress)
FROM [Nashville-housing] a
JOIN [Nashville-housing] b
ON a.ParcelID =b.ParcelID
AND a.[UniqueID ] = b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


------------------------------------------------------------------------------------
---Breaking out address into individual columns (Address, City, State).
------------------------------------------------------------------------------------


SELECT PropertyAddress
FROM [Nashville-housing]


SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
FROM [Nashville-housing]


ALTER TABLE  [Nashville-housing]
ADD PropertySplitAddress Nvarchar(255);

UPDATE [Nashville-housing]
SET PropertySplitAddress = SUBSTRING( PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE  [Nashville-housing]
ADD PropertySplitCity Nvarchar(255);

UPDATE [Nashville-housing]
SET PropertySplitCity = SUBSTRING( PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN (PropertyAddress))



SELECT *
FROM [Nashville-housing]


SELECT OwnerAddress
FROM [Nashville-housing]

SELECT

PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM [Nashville-housing]

ALTER TABLE [Nashville-Housing]
ADD OwnerSplitAddress Nvarchar(255);


UPDATE [Nashville-Housing]
SET OwnerSplitAddress = 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER TABLE [Nashville-Housing]
ADD OwnerSplitCity Nvarchar(255);

UPDATE [Nashville-Housing]
SET OwnerSplitAddress = 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


ALTER TABLE [Nashville-Housing]
ADD OwnerSplitState Nvarchar(255);

UPDATE [Nashville-Housing]
SET OwnerSplitAddress = 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


select *
from [Nashville-housing]

---------------------------------------------------------------------------------------------
--Changing Y and N to Yes and NO in "Sold as Vacant " field
---------------------------------------------------------------------------------------------


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [Nashville-housing]
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN ' No'
	 WHEN SoldAsVacant = ' No' THEN 'No'
	 ELSE SoldAsVacant
	 END 

FROM [Nashville-housing]

UPDATE [Nashville-housing]
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN ' No'
	  WHEN SoldAsVacant = ' No' THEN 'No'
	 ELSE SoldAsVacant
	 END 


--------------------------------------------------------------------------
---Removing duplicates
--------------------------------------------------------------------------

WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY ParcelID,
                              PropertyAddress,
							  SalePrice,
							  SaleDate,
							  LegalReference
							  ORDER BY 
							  UniqueID
							  ) row_num

FROM [Nashville-housing]
)

SELECT * 
FROM RowNumCTE
WHERE row_num > 1


-------------------------------------------------------------------------
--Deleting Unused Columns
-------------------------------------------------------------------------

SELECT * 
FROM [Nashville-housing]

ALTER TABLE [Nashville-housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


----Now our data is more understandable and usable for visualizations.



















