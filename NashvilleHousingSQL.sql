--------------------------------------------------------------------------------------
/*
Cleaning Data in SQL Queries

*/

Select *
From portfolioproject.dbo.NashvilleHousing


-- Standardize Data Format

Select SaleDateConverted, CONVERT(Date, SaleDate)
From portfolioproject.dbo.NashvilleHousing

Alter Table portfolioproject.dbo.NashvilleHousing
Add SaleDateConverted Date;

Update portfolioproject.dbo.NashvilleHousing
Set SaleDateConverted = Convert(date, SaleDate)




--------------------------------------------------------------------------------------
--Populate Property Address data

Select *
From portfolioproject.dbo.NashvilleHousing
--Where PropertyAddress is null
Order By ParcelID



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






--------------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From portfolioproject.dbo.NashvilleHousing
--Where PropertyAddress is null
--Order by ParcelID

Select
SUBSTRING(Propertyaddress, 1, CHARINDEX(',', propertyAddress) -1) as Address
,SUBSTRING(Propertyaddress, CHARINDEX(',', propertyAddress) +1, LEN(PropertyAddress)) as Address
From portfolioproject.dbo.NashvilleHousing




Alter Table portfolioproject.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update portfolioproject.dbo.NashvilleHousing
Set PropertySplitAddress = SUBSTRING(Propertyaddress, 1, CHARINDEX(',', propertyAddress) -1)

Alter Table portfolioproject.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update portfolioproject.dbo.NashvilleHousing
Set PropertySplitCity = SUBSTRING(Propertyaddress, CHARINDEX(',', propertyAddress) +1, LEN(PropertyAddress))


Select *
From portfolioproject.dbo.NashvilleHousing




Select OwnerAddress
From portfolioproject.dbo.NashvilleHousing


Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From portfolioproject.dbo.NashvilleHousing





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


Select *
From portfolioproject.dbo.NashvilleHousing





--------------------------------------------------------------------------------------
--Change Y and N and No in "Sold as Vacant" field

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


Update portfolioproject.dbo.NashvilleHousing
Set SoldAsVacant = CASE When SoldAsVacant= 'Y' Then 'Yes'
       When SoldAsVacant= 'N' Then 'No'
	   ELSE SoldAsVacant
	   END



--------------------------------------------------------------------------------------
-- Remove Duplicates

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
--Order by ParcelID
)
--Delete
Select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress




--------------------------------------------------------------------------------------
--Delete Unused Columns

Select *
From portfolioproject.dbo.NashvilleHousing

Alter Table portfolioproject.dbo.NashvilleHousing
Drop column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table portfolioproject.dbo.NashvilleHousing
Drop column SaleDate