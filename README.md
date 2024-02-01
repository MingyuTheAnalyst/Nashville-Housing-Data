# Nashville-Housing-Data

### Project Overview
 
This data cleaning project with the Nashville Hosuing data, we handle the data formatting, transforming address column and removing the data we are not using.

### Data Sources

Nashville Housing Data(https://www.kaggle.com/datasets/tmthyjames/nashville-housing-data)

### Tools

- Excel - Data Cleaning
- SQL(SQL Server) - Data Exploration, Data Cleaning

### Data Cleaning

- Standardize Data Format

	![image](https://github.com/MingyuTheAnalyst/Nashville-Housing-Data/assets/88122148/20be1bdf-93a1-4eeb-93db-bc8629e0e393)

  ```sql
  Select SaleDateConverted, CONVERT(Date, SaleDate)
  From portfolioproject.dbo.NashvilleHousing
  
  Alter Table portfolioproject.dbo.NashvilleHousing
  Add SaleDateConverted Date;
  
  Update portfolioproject.dbo.NashvilleHousing
  Set SaleDateConverted = Convert(date, SaleDate)
  ```
	[Data Cleaning-Nashville Housing -SQL code Click](https://github.com/MingyuTheAnalyst/Nashville-Housing-Data/blob/main/NashvilleHousingSQL.sql)
  
- Populate Property Address data

  ```sql
  Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyAddress, b.PropertyAddress)
  From portfolioproject.dbo.NashvilleHousing a
  Join portfolioproject.dbo.NashvilleHousing b
  	on a.ParcelID = b.ParcelID
  	AND a.[UniqueID ]<>b.[UniqueID ]
  Where a.PropertyAddress is null
  
  Update a
  SET PropertyAddress = ISNULL(a.propertyAddress, b.PropertyAddress)
  From portfolioproject.dbo.NashvilleHousing a
  Join portfolioproject.dbo.NashvilleHousing b
  	on a.ParcelID = b.ParcelID
  	AND a.[UniqueID ]<>b.[UniqueID ]
  Where a.PropertyAddress is null
  ```
  
- Breaking out Address into Individual Columns (Address, City, State)

  ```sql
  Alter Table portfolioproject.dbo.NashvilleHousing
  Add OwnerSplitAddress Nvarchar(255);
  Update portfolioproject.dbo.NashvilleHousing
  Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)
  
  Alter Table portfolioproject.dbo.NashvilleHousing
  Add OwnerSplitCity Nvarchar(255);
  Update portfolioproject.dbo.NashvilleHousing
  Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)
  
  
  Alter Table portfolioproject.dbo.NashvilleHousing
  Add OwnerSplitState Nvarchar(255);
  Update portfolioproject.dbo.NashvilleHousing
  Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)
  ```
	 ![image](https://github.com/MingyuTheAnalyst/Nashville-Housing-Data/assets/88122148/7c8d2dcf-f1ac-494e-84fc-1034c584b9ba)

- Change Y and N and No in "Sold as Vacant" field

  ```sql
  Select Distinct(SoldAsVacant), Count(SoldAsVacant)
  From portfolioproject.dbo.NashvilleHousing
  Group by SoldAsVacant
  Order by 2
  
  
  Select SoldAsVacant
  , CASE When SoldAsVacant= 'Y' Then 'Yes'
         When SoldAsVacant= 'N' Then 'No'
  	   ELSE SoldAsVacant
  	   END
  From portfolioproject.dbo.NashvilleHousing
  ```
	![image](https://github.com/MingyuTheAnalyst/Nashville-Housing-Data/assets/88122148/341e638e-999b-4fe9-9cba-750ac9a0fae7)

Update portfolioproject.dbo.NashvilleHousing
Set SoldAsVacant = CASE When SoldAsVacant= 'Y' Then 'Yes'
       When SoldAsVacant= 'N' Then 'No'
	   ELSE SoldAsVacant
	   END
  
- Remove Duplicates
  
  ```sql
  WITH RowNumCTE AS(
  Select *,
 	ROW_NUMBER() OVER (
 	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

   From portfolioproject.dbo.NashvilleHousing
  ```

- Delete Unused Columns
  
  ```sql
  Select *
  From portfolioproject.dbo.NashvilleHousing
  
  Alter Table portfolioproject.dbo.NashvilleHousing
  Drop column OwnerAddress, TaxDistrict, PropertyAddress
  
  Alter Table portfolioproject.dbo.NashvilleHousing
  Drop column SaleDate
  ```
### Key Achievements

 - Improved Data Consistency: Standardized date formats and unified values in the 'Sold as Vacant' field to 'Yes' or 'No' using SQL, significantly enhancing data consistency and readability.
 - Managed Missing Values: Actively identified and supplemented missing property addresses, ensuring the completeness of the dataset.
 - Optimized Data Structure: Separated address information into individual columns and removed unused columns, increasing the ease of analysis.
