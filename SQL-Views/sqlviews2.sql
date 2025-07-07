-- ✅ KPI: Avg Monthly Transactions per Customer
-- This view calculates average number of monthly transactions for each customer.

USE Banking_System;
GO

CREATE VIEW dbo.Avg_Monthly_Transactions_per_Customer AS

-- STEP 1: Link transactions to customer and split by year/month
WITH CustomerTransactions AS (
    SELECT 
        a.CustomerID,
        DATEPART(YEAR, t.Date) AS TxnYear,
        DATEPART(MONTH, t.Date) AS TxnMonth,
        COUNT(*) AS MonthlyTxnCount
    FROM Core_Banking.Transactions t
    JOIN Core_Banking.Accounts a ON t.AccountID = a.AccountID
    GROUP BY a.CustomerID, DATEPART(YEAR, t.Date), DATEPART(MONTH, t.Date)
),

-- STEP 2: Average transaction per customer
AvgMonthlyTxnPerCustomer AS (
    SELECT 
        CustomerID,
        AVG(MonthlyTxnCount * 1.0) AS AvgMonthlyTransactions
    FROM CustomerTransactions
    GROUP BY CustomerID
)

-- STEP 3: Join with customer details
SELECT 
    c.CustomerID,
    c.FullName,
    a.AvgMonthlyTransactions,
    c.AnnualIncome,
    c.EmploymentStatus,
    c.CreatedAt
FROM AvgMonthlyTxnPerCustomer a
JOIN Core_Banking.Customers c ON c.CustomerID = a.CustomerID;

select * from dbo.Avg_Monthly_Transactions_per_Customer

-- ✅ KPI: Top 3 Customers with Highest Total Balance

USE Banking_System;
GO

CREATE VIEW dbo.Top_3_Customers_Highest_Balance AS
SELECT TOP 3
    c.CustomerID,
    c.FullName,
    SUM(a.Balance) AS TotalBalance
FROM Core_Banking.Accounts a
JOIN Core_Banking.Customers c ON c.CustomerID = a.CustomerID
GROUP BY c.CustomerID, c.FullName
ORDER BY TotalBalance DESC;

select * from dbo.Top_3_Customers_Highest_Balance

-- ✅ KPI: Total Loan Amount Issued per Branch

USE Banking_System;
GO

CREATE VIEW dbo.Total_Loan_Amount_per_Branch AS
SELECT 
    b.BranchID,
    b.BranchName,
    SUM(l.Amount) AS TotalLoanAmount
FROM Loans_Credit.Loans l
JOIN Core_Banking.Customers c ON l.CustomerID = c.CustomerID
JOIN Core_Banking.Accounts a ON c.CustomerID = a.CustomerID
JOIN Core_Banking.Branches b ON a.BranchID = b.BranchID
GROUP BY b.BranchID, b.BranchName;

select * from dbo.Total_Loan_Amount_per_Branch

-- ✅ KPI: Transactions Flagged as Fraudulent

USE Banking_System;
GO

CREATE VIEW dbo.Fraudulent_Transactions AS
SELECT 
    t.TransactionID,
    c.CustomerID,
    c.FullName,
    t.Amount,
    t.Date,
    f.RiskLevel,
    f.ReportedDate
FROM Compliance_Risk.FraudDetection f
JOIN Core_Banking.Transactions t ON t.TransactionID = f.TransactionID
JOIN Core_Banking.Accounts a ON t.AccountID = a.AccountID
JOIN Core_Banking.Customers c ON a.CustomerID = c.CustomerID;

select * from dbo.Fraudulent_Transactions
