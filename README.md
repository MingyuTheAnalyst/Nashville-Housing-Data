# Nashville-Housing-Data

### Project Overview
 
This data cleaning project with the Nashville Hosuing data, we will hand the data formatting, transforming address column and removing the data we are not using.

### Data Sources

Nashville Housing Data(https://www.kaggle.com/datasets/tmthyjames/nashville-housing-data)

### Tools

- Excel - Data Cleaning
- SQL(MSSQL) - Data Exploration, Data Cleaning

### Data Cleaning

[Data Cleaning-Nashville Housing -SQL code](https://github.com/MingyuTheAnalyst/Nashville-Housing-Data/blob/main/NashvilleHousingSQL.sql)

- Standardize Data Format
- Populate Property Address data
- Breaking out Address into Individual Columns (Address, City, State)
- Change Y and N and No in "Sold as Vacant" field
- Remove Duplicates
- Delete Unused Columns

Include some interesting code/features worked with
```sql
Select
    SaleDateConverted,
    CONVERT(Date, SaleDate)
From
    portfolioproject.dbo.NashvilleHousing

Alter Table
    portfolioproject.dbo.NashvilleHousing
Add
    SaleDateConverted Date;

Update
    portfolioproject.dbo.NashvilleHousing
Set
    SaleDateConverted = Convert(date, SaleDate)
```
