

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
