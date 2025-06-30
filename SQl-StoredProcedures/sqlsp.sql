-- STORED PROCEDURES

use Banking_System

-- 1 -- sp_GetBranchInsights --

Create proc sp_GetBranchInsights @BranchID int
As
Begin
    Select
        b.BranchName,
        count(distinct a.CustomerID) as TotalCustomers,
        count(a.AccountID) as TotalAccounts,
        sum(a.Balance) as TotalAccountBalance,
        count(distinct l.LoanID) as TotalLoansIssued,
        count(distinct e.EmployeeID) as ActiveEmployeeCount
    From core_banking.branches b
    Left join core_banking.accounts a on a.BranchID = b.BranchID
    Left join core_banking.customers c on a.CustomerID = c.CustomerID
    Left join loans_credit.loans l on l.CustomerID = c.CustomerID
    Left join core_banking.employees e on e.BranchID = b.BranchID and e.Status = 'Active'
    Where b.BranchID = @BranchID
    Group by b.BranchName
End

Exec sp_GetBranchInsights @BranchID = 2;

-- Tables used

Select * from core_banking.branches
Select * from core_banking.accounts
Select * from core_banking.customers
Select * from loans_credit.loans
Select * from core_banking.employees


-- 2 -- sp_GetCustomerFinancialProfile --

Create Proc sp_GetCustomerFinancialProfile @CustomerID int
As
Begin
    Select 
        c.FullName,
        c.DOB,
        c.Email,
        count(distinct a.AccountID) as TotalAccounts,
        isnull(sum(a.Balance), 0) as TotalBalance,
        count(distinct t.TransactionID) as TotalTransactions,
        count(distinct l.LoanID) as TotalLoans,
        isnull(sum(l.Amount), 0) as TotalLoaned,
        isnull(sum(lp.AmountPaid), 0) as TotalRepaid,
        isnull(sum(l.Amount), 0) - isnull(sum(lp.AmountPaid), 0) as LoanOutstanding
    From core_banking.customers c
    Left join core_banking.accounts a on c.CustomerID = a.CustomerID
    Left join core_banking.transactions t on a.AccountID = t.AccountID
    Left join loans_credit.loans l on c.CustomerID = l.CustomerID
    Left join loans_credit.loanpayments lp on l.LoanID = lp.LoanID
    Where c.CustomerID = @CustomerID
    Group by c.FullName, c.DOB, c.Email
End

Exec sp_GetCustomerFinancialProfile @CustomerID = 100;

-- Tables used

Select * from core_banking.customers
Select * from core_banking.accounts
Select * from loans_credit.loans
Select * from core_banking.transactions
Select * from loans_credit.loanpayments


-- 3 -- sp_EvaluateLoanRequest --

Create proc sp_EvaluateLoanRequest @CustomerID int, @RequestedAmount decimal(18,2)
As
Begin
    Declare @Score int, @Rate decimal(5,2), @Eval nvarchar(20), @Rec nvarchar(30), @TotalPayable decimal(18,2);

    Select @Score = CreditScore from loans_credit.creditscores
    Where CustomerID = @CustomerID;

    If @Score >= 750
    Begin
        set @Rate = 0.08;
        set @Eval = 'Excellent';
        set @Rec = 'Approved';
    End
    Else if @Score >= 650
    Begin
        Set @Rate = 0.10;
        Set @Eval = 'Good';
        Set @Rec = 'Consider Approval';
    End
    Else if @Score >= 550
    Begin
        Set @Rate = 0.13;
        Set @Eval = 'Fair';
        Set @Rec = 'Monitor Closely';
    End
    Else
    Begin
        Set @Rate = 0.00;
        Set @Eval = 'Poor';
        Set @Rec = 'Do Not Approve';
    End

    Set @TotalPayable = @RequestedAmount * (1 + @Rate);

    Select 
        c.CustomerID,
        c.FullName,
        c.NationalID,
        c.TaxID,
        @Score as CreditScore,
        @Eval as EvaluationCategory,
        @Rec as Recommendation,
        @Rate * 100 as InterestRatePercent,
        @RequestedAmount as RequestedAmount,
        @TotalPayable as TotalAmountWithInterest
    From core_banking.customers c
    Where c.CustomerID = @CustomerID;
End

Exec sp_EvaluateLoanRequest @CustomerID = 100, @RequestedAmount = 30000;



-- Tables used

Select * from loans_credit.creditscores
Select * from core_banking.customers


-- 4 -- sp_GetEmployeeProfile --

Create proc sp_GetEmployeeProfile @EmployeeID int
As
Begin
    Select 
        e.EmployeeID,
        e.FullName,
        e.Position,
        e.Department,
        b.BranchName,
        e.Salary as MonthlyBaseSalary,
        count(a.AttendanceID) as TotalAttendanceRecords,
        isnull(sum(a.TotalHours), 0) as TotalHoursWorked,
        e.HireDate,
        e.Status
    From core_banking.employees e
    Left join core_banking.branches b on e.BranchID = b.BranchID
    Left join human_resources.employeeattendance a on e.EmployeeID = a.EmployeeID
    Where e.EmployeeID = @EmployeeID
    Group by 
        e.EmployeeID, e.FullName, e.Position, e.Department,
        b.BranchName, e.Salary, e.HireDate, e.Status
End


Exec sp_GetEmployeeProfile @EmployeeID = 4;

-- Tables used

Select * from core_banking.employees
Select * from core_banking.branches
Select * from human_resources.salaries
Select * from human_resources.employeeattendance
