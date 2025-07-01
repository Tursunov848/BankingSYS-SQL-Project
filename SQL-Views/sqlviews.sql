-- Views --

select * from [Core_Banking].[Transactions]
select * from [Core_Banking].Accounts
select * from [Core_Banking].Customers

---Avg_Monthly_Transactions_per_Customer---Har bir mijoz uchun oylik o‘rtacha tranzaksiyalar sonini hisoblang 

create view Avg_Monthly_Transactions_per_Customer as
-- Step 1: Barcha tranzaksiyalarni mijozga bog‘laymiz va sana formatlaymiz
with CustomerTransactions as (
    select 
        a.CustomerID,
        datepart(year, t.Date) as TxnYear,
        datepart(month, t.Date) as TxnMonth,
        count(*) as MonthlyTxnCount
    from [Core_Banking].Transactions t
     join [Core_Banking].Accounts a on t.AccountID = a.AccountID
    group by a.CustomerID, datepart(year, t.Date), datepart(month, t.Date)
),

-- Step 2: Har bir mijoz bo‘yicha oylik o‘rtacha tranzaksiya soni
AvgMonthlyTxnPerCustomer as (
    select 
        CustomerID,
        avg(MonthlyTxnCount * 1.0) as AvgMonthlyTransactions
    from CustomerTransactions
    group by CustomerID
)

select 
    c.CustomerID,
    c.FullName,
    a.AvgMonthlyTransactions,
    c.AnnualIncome,
    c.EmploymentStatus,
    c.CreatedAt
from AvgMonthlyTxnPerCustomer a
join [Core_Banking].Customers c on c.CustomerID = a.CustomerID



select * from Avg_Monthly_Transactions_per_Customer
order by  AvgMonthlyTransactions desc;



---Avg_Monthly_Transactions_per_Customer_1year---Har bir mijoz uchun oylik o‘rtacha tranzaksiyalar sonini hisoblang ohirgi 1 yil

create view Avg_Monthly_Transactions_per_Customer_1year as

with CustomerTransactions as (
    select 
        a.CustomerID,
        datepart(year, t.Date) as TxnYear,
        datepart(month, t.Date) as TxnMonth,
        count(*) as MonthlyTxnCount
    from [Core_Banking].Transactions t
    join [Core_Banking].Accounts a on t.AccountID = a.AccountID
    where t.Date >= dateadd(year, -1, GETDATE())  -- Only last 12 months
    group by a.CustomerID, datepart(year, t.Date), datepart(month, t.Date)
),

AvgMonthlyTxnPerCustomer as (
    select 
        CustomerID,
        avg(MonthlyTxnCount * 1.0) as AvgMonthlyTransactions
    from CustomerTransactions
    group by CustomerID
)

select 
    c.CustomerID,
    c.FullName,
    a.AvgMonthlyTransactions,
    c.AnnualIncome,
    c.EmploymentStatus,
    c.CreatedAt
from AvgMonthlyTxnPerCustomer a
join [Core_Banking].Customers c on c.CustomerID = a.CustomerID

select * from Avg_Monthly_Transactions_per_Customer_1year
order by  AvgMonthlyTransactions desc;



---Fraud_HighValue_QuickTxns---1 soat ichida 10.000 ko'p tranzakshin qiganla chiqadi 

select * from [Core_Banking].[Transactions]
select * from [Core_Banking].Accounts
select * from [Core_Banking].Customers



create view Fraud_HighValue_QuickTxns as

with HighValueTxns as (
    select 
        t.TransactionID,
        a.CustomerID,
        t.AccountID,
        t.Amount,
        t.Date as TxnDate
    from Core_Banking.Transactions t
     join Core_Banking.Accounts a on t.AccountID = a.AccountID
    where 
        t.Amount > 10000 AND 
        t.Status = 'Completed'
),

TxnPairs as (
    select 
        h1.CustomerID,
        h1.TransactionID as TxnID1,
        h1.TxnDate as TxnDate1,
        h2.TransactionID as TxnID2,
        h2.TxnDate as TxnDate2,
        datediff(minute, h1.TxnDate, h2.TxnDate) as MinutesDiff
    from HighValueTxns h1
     join HighValueTxns h2 
        on h1.CustomerID = h2.CustomerID
        AND h1.TransactionID < h2.TransactionID
        AND abc(datediff(minute, h1.TxnDate, h2.TxnDate)) < 60
),

QualifiedCustomers as (
    select distinct CustomerID from TxnPairs
)

select 
    c.CustomerID,
    c.FullName,

    -- Total number of high-value transactions
    count(distinct t1.TransactionID) as HighValueTxnCount,
	sum(t1.Amount) as TotalHighValueAmount,

    -- Earliest and latest transaction dates
    min(t1.Date) as FirstTxnDate,
    max(t1.Date) as LastTxnDate,

	-- Shubhali tranzaksiya juftliklari orasidagi o'rtacha vaqt farqi
    (
        select avg(abc(datediff(minute, p.TxnDate1, p.TxnDate2))) 
        from TxnPairs p 
        where p.CustomerID = c.CustomerID
    ) as Difference_between_transactions,

    -- Nechta turli akkaunt ishlatilgan
    count(distinct a.AccountID) as InvolvedAccounts

from QualifiedCustomers qc
join Core_Banking.Customers c on c.CustomerID = qc.CustomerID
join Core_Banking.Accounts a on a.CustomerID = c.CustomerID
join Core_Banking.Transactions t1 on t1.AccountID = a.AccountID
where 
    t1.Amount > 10000 AND 
    t1.Status = 'Completed'

group by c.CustomerID, c.FullName;

select * from Fraud_HighValue_QuickTxns













---Fraud_CrossCountry_QuickTxns---10 daqiqadan kam vaqt ichida bir xil mijoz (CustomerID) tomonidan turli mamlakatlardan 
--(Country) tranzaksiya amalga oshirilgan bo‘lsa — bu firibgarlik (fraud) ehtimolini bildiradi.

create view Fraud_CrossCountry_QuickTxns as

with TxnsWithCountry as (
    select 
        t.TransactionID,
        a.CustomerID,
        t.AccountID,
        t.Date as TxnDate,
        b.Country
    from Core_Banking.Transactions t
     join Core_Banking.Accounts a on t.AccountID = a.AccountID
     join Core_Banking.Branches b on a.BranchID = b.BranchID
    where t.Status = 'Completed' AND b.Country is not null
),

TxnPairs as (
    select 
        t1.CustomerID,
        t1.TransactionID as TxnID1,
        t1.TxnDate as TxnDate1,
        t1.Country as Country1,
        t2.TransactionID as TxnID2,
        t2.TxnDate as TxnDate2,
        t2.Country as Country2,
        datediff(minute, t1.TxnDate, t2.TxnDate) as MinutesDiff
    from TxnsWithCountry t1
    join TxnsWithCountry t2
        on t1.CustomerID = t2.CustomerID
        AND t1.TransactionID < t2.TransactionID
        AND abc(datediff(minute, t1.TxnDate, t2.TxnDate)) < 10
        AND t1.Country <> t2.Country
),

FlaggedCustomers as (
    select distinct CustomerID from TxnPairs
)

select 
    c.CustomerID,
    c.FullName,
    count(distinct t.TransactionID) as TotalTxns,
    max(t.Date) as LastTxnDate,
    count(distinct b.Country) as UniqueCountriesUsed,

    (
        select avg(abc(datediff(minute, p.TxnDate1, p.TxnDate2))) 
        from TxnPairs p where p.CustomerID = c.CustomerID
    ) as AvgMinutesBetweenCrossCountryTxns,

--Barcha Completed tranzaksiyalarning umumiy summasi (USD da).
sum(case when t.Currency = 'USD' then t.Amount 
         when t.Currency = 'EUR' then t.Amount * 1.1  -- Sample conversion
         when t.Currency = 'UZS' then t.Amount / 12500
         else t.Amount end) as TotalTxnAmountUSD,
max(b.Country) as LastCountryUsed




from FlaggedCustomers fc
join Core_Banking.Customers c on c.CustomerID = fc.CustomerID
join Core_Banking.Accounts a on a.CustomerID = c.CustomerID
join Core_Banking.Transactions t on t.AccountID = a.AccountID AND t.Status = 'Completed'
join Core_Banking.Branches b on a.BranchID = b.BranchID
group by c.CustomerID, c.FullName;


select * from Fraud_CrossCountry_QuickTxns

--Suspicious Customer   	CustomerID, FullName	            Asosiy identifikator
--Txn Pairs <10 min	        CrossCountryTxnPairs                Hodisalar soni
--avg Minutes Between	    AvgMinutesBetweenCrossCountryTxns	Davomiylik
--Countries Used	        UniqueCountriesUsed	                Lokatsiya tahdidi
--Total Txn Amount USD	    TotalTxnAmountUSD	                Risk qiymati
--First & Last Txn Country	FirstCountryUsed, LastCountryUsed	Lokatsiya ketma-ketligi







---Customers_With_Multiple_Active_Loans---bu kredit risk monitoring va fraud audit uchun muhim KPI hisoblanadi.

create view Customers_With_Multiple_Active_Loans as
select 
    c.CustomerID,
    c.FullName,

    count(l.LoanID) as ActiveLoanCount,
    count(distinct a.AccountID) as TotalAccounts,

    sum(l.Amount) as TotalLoanAmount,
    max(l.Amount) as MaxSingleLoanAmount,

    min(l.StartDate) as FirstLoanStartDate,
    max(l.EndDate) as LastLoanEndDate,
    datediff(day, min(l.StartDate), max(l.EndDate)) as LoanSpanDays

from Loans_Credit.Loans l
join Core_Banking.Customers c on c.CustomerID = l.CustomerID
LEFT join Core_Banking.Accounts a on a.CustomerID = c.CustomerID

where isnull(l.Status, '') = 'Active'

group by c.CustomerID, c.FullName
having count(l.LoanID) > 1;





---Customers_With_Repayment_Delays---Ushbu KPI orqali qarzni kechiktirib to‘layotgan mijozlar aniqlanadi. 
--Har bir mijozning nechta marta to‘lovni muddati o‘tgach to‘lagani hisoblanadi.

create view Customers_With_Repayment_Delays as
select
    c.CustomerID,
    c.FullName,
    count(lp.PaymentID) as TotalPayments,
    
    -- Nechta to‘lov muddati o‘tgach to‘langan
    sum(case 
        when lp.PaymentDate > l.EndDate then 1 
        else 0 
    end) as LatePaymentsCount,

    -- Kechiktirib to‘langan to‘lovlarning ulushi (%)
    round(
        100.0 * sum(case when lp.PaymentDate > l.EndDate then 1 else 0 end) / count(lp.PaymentID), 
        2
    ) as LatePaymentRatioPercent

from Loans_Credit.LoanPayments lp
join Loans_Credit.Loans l on lp.LoanID = l.LoanID
join Core_Banking.Customers c on c.CustomerID = l.CustomerID

where l.Status = 'Active'  -- faqat faol kreditlar uchun

group by c.CustomerID, c.FullName
having sum(case when lp.PaymentDate > l.EndDate then 1 else 0 end) > 0;


select * from Customers_With_Repayment_Delays
order by  LatePaymentsCount desc
