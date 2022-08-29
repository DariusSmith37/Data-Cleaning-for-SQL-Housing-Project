/*

Data Cleaning for SQL Housing Project

*/



Select *
From [Portfolio Project].dbo.NashvilleHousing



-- Formating Date



Select SaleDateConverted, Convert(Date,SaleDate)
From [Portfolio Project].dbo.NashvilleHousing


Alter Table NashvilleHousing
Add SaleDateConverted Date;


Update NashvilleHousing
Set SaleDateConverted = Convert(Date,SaleDate)





-- Populate Property Address Data



Select *
From [Portfolio Project].dbo.NashvilleHousing
Where PropertyAddress is null
Order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project].dbo.NashvilleHousing a
Join [Portfolio Project].dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
	Where a.PropertyAddress is null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project].dbo.NashvilleHousing a
Join [Portfolio Project].dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]




-- Seperating Address Into Individidual Columns (Address, City, State)



Select PropertyAddress
From [Portfolio Project].dbo.NashvilleHousing
--Where PropertyAddress is Null
--Order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address

From [Portfolio Project].dbo.NashvilleHousing


Alter Table NashvilleHousing
Add PropertySplitAddress NVARCHAR(255);


Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


Alter Table NashvilleHousing
Add PropertySplitCity NVARCHAR(255);


Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))




Select OwnerAddress
From [Portfolio Project].dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) as OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) as OwnerCity,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) as OwnerState
From [Portfolio Project].dbo.NashvilleHousing


Alter Table NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255);


Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


Alter Table NashvilleHousing
Add OwnerSplitCity NVARCHAR(255);


Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) 


Alter Table NashvilleHousing
Add OwnerSplitState NVARCHAR(255);


Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



Select *
From [Portfolio Project].dbo.NashvilleHousing




-- Change Y and N to YES and No in "Sold as Vacant" field



Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Portfolio Project].dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2



Select SoldAsVacant
,CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 When SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
From [Portfolio Project].dbo.NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 When SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END




--Removes Duplicates


WITH ROWNUMCTE AS(
Select *,
  ROW_NUMBER() OVER (
  PARTITION BY ParcelID,
               PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   Order By
			   UniqueID
			   ) row_num


FROM [Portfolio Project].dbo.NashvilleHousing
--Order By ParcelID
)

SELECT *
FROM ROWNUMCTE
Where row_num > 1
--Order by PropertyAddress



-- Delete Unused Columns



Select *
From [Portfolio Project].dbo.NashvilleHousing


Alter Table [Portfolio Project].dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


Alter Table [Portfolio Project].dbo.NashvilleHousing
DROP COLUMN SaleDate





