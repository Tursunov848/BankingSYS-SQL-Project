create database Banking_System 
create schema staging
use Banking_System

--1. Customers
create table staging.stg_customers (
    customer_id int,
    full_name varchar(100),
    dob date,
    email varchar(100),
    phone_number varchar(20),
    address varchar(200),
    national_id varchar(20),
    tax_id varchar(20),
    employment_status varchar(50),
    annual_income decimal(18,2),
    created_at datetime,
    updated_at datetime
);
--2. Accounts
create table staging.stg_accounts (
    account_id int,
    customer_id int,
    account_type varchar(30),
    balance decimal(18,2),
    currency varchar(10),
    status varchar(20),
    branch_id int,
    created_date date
);
--3. Transactions
create table staging.stg_transactions (
    transaction_id int,
    account_id int,
    transaction_type varchar(30),
    amount decimal(18,2),
    currency varchar(10),
    date datetime,
    status varchar(20),
    reference_no varchar(50)
);
--4. Branches
create table staging.stg_branches (
    branch_id int,
    branch_name varchar(100),
    address varchar(200),
    city varchar(50),
    state varchar(50),
    country varchar(50),
    manager_id int,
    contact_number varchar(20)
);
--5. Employees
create table staging.stg_employees (
    employee_id int,
    branch_id int,
    full_name varchar(100),
    position varchar(50),
    department varchar(50),
    salary decimal(18,2),
    hire_date date,
    status varchar(20)
);
--💳 Digital Banking & Payments
--6. CreditCards
create table staging.stg_credit_cards (
    card_id int,
    customer_id int,
    card_number varchar(20),
    card_type varchar(30),
    cvv varchar(5),
    expiry_date date,
    limit decimal(18,2),
    status varchar(20)
);
--7. CreditCardTransactions
create table staging.stg_credit_card_transactions (
    transaction_id int,
    card_id int,
    merchant varchar(100),
    amount decimal(18,2),
    currency varchar(10),
    date datetime,
    status varchar(20)
);
--8. OnlineBankingUsers
create table staging.stg_online_banking_users (
    user_id int,
    customer_id int,
    username varchar(50),
    password_hash varchar(200),
    last_login datetime
);
--9. BillPayments
create table staging.stg_bill_payments (
    payment_id int,
    customer_id int,
    biller_name varchar(100),
    amount decimal(18,2),
    date date,
    status varchar(20)
);
--10. MobileBankingTransactions
create table staging.stg_mobile_banking_transactions (
    transaction_id int,
    customer_id int,
    device_id varchar(50),
    app_version varchar(20),
    transaction_type varchar(30),
    amount decimal(18,2),
    date datetime
);
--🏦 Loans & Credit
--11. Loans
create table staging.stg_loans (
    loan_id int,
    customer_id int,
    loan_type varchar(50),
    amount decimal(18,2),
    interest_rate decimal(5,2),
    start_date date,
    end_date date,
    status varchar(20)
);
--12. LoanPayments
create table staging.stg_loan_payments (
    payment_id int,
    loan_id int,
    amount_paid decimal(18,2),
    payment_date date,
    remaining_balance decimal(18,2)
);
--13. CreditScores
create table staging.stg_credit_scores (
    customer_id int,
    credit_score int,
    updated_at datetime
);
--14. DebtCollection
create table staging.stg_debt_collection (
    debt_id int,
    customer_id int,
    amount_due decimal(18,2),
    due_date date,
    collector_assigned varchar(100)
);
--📊 Compliance & Risk
--15. KYC
create table staging.stg_kyc (
    kyc_id int,
    customer_id int,
    document_type varchar(50),
    document_number varchar(50),
    verified_by varchar(100)
);
--16. FraudDetection
create table staging.stg_fraud_detection (
    fraud_id int,
    customer_id int,
    transaction_id int,
    risk_level varchar(20),
    reported_date date
);
--17. AML Cases
create table staging.stg_aml_cases (
    case_id int,
    customer_id int,
    case_type varchar(50),
    status varchar(20),
    investigator_id int
);
--18. RegulatoryReports
create table staging.stg_regulatory_reports (
    report_id int,
    report_type varchar(100),
    submission_date date
);
--🧑‍💼 Human Resources
--19. Departments
create table staging.stg_departments (
    department_id int,
    department_name varchar(100),
    manager_id int
);
--20. Salaries
create table staging.stg_salaries (
    salary_id int,
    employee_id int,
    base_salary decimal(18,2),
    bonus decimal(18,2),
    deductions decimal(18,2),
    payment_date date
);
--21. EmployeeAttendance
create table staging.stg_employee_attendance (
    attendance_id int,
    employee_id int,
    check_in_time datetime,
    check_out_time datetime,
    total_hours decimal(5,2)
);
--📈 Investments & Treasury
--22. Investments
create table staging.stg_investments (
    investment_id int,
    customer_id int,
    investment_type varchar(50),
    amount decimal(18,2),
    roi decimal(5,2),
    maturity_date date
);
--23. StockTradingAccounts
create table staging.stg_stock_trading_accounts (
    account_id int,
    customer_id int,
    brokerage_firm varchar(100),
    total_invested decimal(18,2),
    current_value decimal(18,2)
);
--24. ForeignExchange
create table staging.stg_foreign_exchange (
    fx_id int,
    customer_id int,
    currency_pair varchar(20),
    exchange_rate decimal(10,4),
    amount_exchanged decimal(18,2)
);
--📜 Insurance & Security
--25. InsurancePolicies
create table staging.stg_insurance_policies (
    policy_id int,
    customer_id int,
    insurance_type varchar(50),
    premium_amount decimal(18,2),
    coverage_amount decimal(18,2)
);
--26. Claims
create table staging.stg_claims (
    claim_id int,
    policy_id int,
    claim_amount decimal(18,2),
    status varchar(20),
    filed_date date
);
--27. UserAccessLogsCREATE table staging.stg_user_access_logs (
create table staging.stg_user_access_logs (
    log_id int,
    user_id int,
    action_type varchar(50),
    timestamp datetime
);
--28. CyberSecurityIncidents
create table staging.stg_cyber_security_incidents (
    incident_id int,
    affected_system varchar(100),
    reported_date date,
    resolution_status varchar(50)
);
--🛒 Merchant Services
--29. Merchants
create table staging.stg_merchants (
    merchant_id int,
    merchant_name varchar(100),
    industry varchar(50),
    location varchar(100),
    customer_id int
);
--30. MerchantTransactions
create table staging.stg_merchant_transactions (
    transaction_id int,
    merchant_id int,
    amount decimal(18,2),
    payment_method varchar(30),
    date date
);



