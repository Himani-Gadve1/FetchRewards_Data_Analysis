# FetchRewards_Data_Analysis

ER - diagram, Data Analysis and SQL script has been uploaded on Github repositor
Raw data files can be found  [here](https://github.com/Himani-Gadve1/FetchRewards_Data_Analysis/blob/main/ER%20diagram/ER%20diagram.pdf)

# Part 1: Data Modelling:
Diagrams.net has been used to design the ER diagram.

Data:
3 raw files in Json.gz format

## File 1: users.json
Attributes:

    _id: user Id
    state: state abbreviation
    createdDate: when the user created their account
    lastLogin: last time the user was recorded logging in to the app
    role: constant value set to 'CONSUMER'
    active: indicates if the user is active; only Fetch will de-activate an account with this flag

## File 2: brands.json
Attributes:

    _id: brand uuid
    barcode: the barcode on the item
    brandCode: String that corresponds with the brand column in a partner product file
    category: The category name for which the brand sells products in
    categoryCode: The category code that references a BrandCategory
    cpg: reference to CPG collection
    topBrand: Boolean indicator for whether the brand should be featured as a 'top brand'
    name: Brand name

## File 3: receipts.json
Attributes:

    _id: uuid for this receipt
    bonusPointsEarned: Number of bonus points that were awarded upon receipt completion
    bonusPointsEarnedReason: event that triggered bonus points
    createDate: The date that the event was created
    dateScanned: Date that the user scanned their receipt
    finishedDate: Date that the receipt finished processing
    modifyDate: The date the event was modified
    pointsAwardedDate: The date we awarded points for the transaction
    pointsEarned: The number of points earned for the receipt
    purchaseDate: the date of the purchase
    purchasedItemCount: Count of number of items on the receipt
    rewardsReceiptItemList: The items that were purchased on the receipt
    rewardsReceiptStatus: status of the receipt through receipt validation and processing
    totalSpent: The total amount on the receipt
    userId: string id back to the User collection for the user who scanned the receipt


As I proceed with the data. It has been observed that receipts.json file was nested JSON. So I separated the receipts and receipt order data and linked them with receiptId in common.

# Part 2: Queries to answer business questions

1. What are the top 5 brands by receipts scanned for most recent month?

2. How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?

3. When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

4. When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

5. Which brand has the most spend among users who were created within the past 6 months?

6. Which brand has the most transactions among users who were created within the past 6 months?

Database: PostgreSQL - Presto. Read [SQL script](https://github.com/Himani-Gadve1/FetchRewards_Data_Analysis/blob/main/SQL%20script/FetchRewards.sql)

# Part 3: Data quality issue:

After analyzing data found couple of flaws which are listed below:
Below couple of flaws in the data and has been described in the [jupyter notebook](https://github.com/Himani-Gadve1/FetchRewards_Data_Analysis/blob/main/Jupyter%20notebook/Fetch%20Rewards%20Data%20Analyst.ipynb)

    1. There are some null and missing values in the data. Data has be cleaned by removing these null and missing values which ever found irrelevant to the data and analysis.
    2. User data file has a duplicate User_id.
    3. There were cases where reward points were awarded although there is no information on the receipt item list.
    4. While ansswering the business model question : 'When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which          is greater?'
    5. The column name brandCode is present in brands.json and receipts.json files. But the values do not match each other. I am assuming that both the columns have        different meanings, hence the names of those columns need to be changed accordingly.

-> There is no'Accepted' or 'Rejected' status in the 'rewardsReceiptStatus'. It has below mentioned 5 status with the count of those records

        FINISHED 518
        SUBMITTED 434
        REJECTED 71
        PENDING 50
        FLAGGED 46
