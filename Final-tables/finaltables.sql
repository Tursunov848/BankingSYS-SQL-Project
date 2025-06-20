--faynil table
create schema Core_Banking
create schema Digital_Banking_Payments
create schema Loans_Credit
create schema Compliance_Risk
create schema Human_Resources
create schema Investments_Treasury
create schema Insurance_Security
create schema Merchant_Services

--1. Customers
create table Core_Banking.customers (
    customer_id int primary key,
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

--2. Branches

create table Core_Banking.branches (
    branch_id int primary key,
    branch_name varchar(100),
    address varchar(200),
    city varchar(50),
    state varchar(50),
    country varchar(50),
    manager_id int,
    contact_number varchar(20)
);
--3. Employees

create table Core_Banking.employees (
    employee_id int primary key,
    branch_id int,
    full_name varchar(100),
    position varchar(50),
    department varchar(50),
    salary decimal(18,2),
    hire_date date,
    status varchar(20),
    foreign key (branch_id) references Core_Banking.branches(branch_id)
);

--4. Accounts

create table Core_Banking.accounts (
    account_id int primary key,
    customer_id int,
    account_type varchar(30),
    balance decimal(18,2),
    currency varchar(10),
    status varchar(20),
    branch_id int,
    created_date date,
    foreign key (customer_id) references Core_Banking.customers(customer_id),
    foreign key (branch_id) references Core_Banking.branches(branch_id)
);

--5. Transactions

create table Core_Banking.transactions (
    transaction_id int primary key,
    account_id int,
    transaction_type varchar(30),
    amount decimal(18,2),
    currency varchar(10),
    date datetime,
    status varchar(20),
    reference_no varchar(50),
    foreign key (account_id) references Core_Banking.accounts(account_id)
);

--💳 Digital Banking & Payments
--6. CreditCards
 
create table Digital_Banking_Payments.credit_cards (
    card_id int primary key,
    customer_id int,
    card_number varchar(20),
    card_type varchar(30),
    cvv varchar(5),
    expiry_date date,
    limit decimal(18,2),
    status varchar(20),
    Constraint fk_credit_cards_customers foreign key (customer_id) references Core_Banking.customers(customer_id)
);
--7. CreditCardTransactions

create table Digital_Banking_Payments.credit_card_transactions (
    transaction_id int primary key,
    card_id int,
    merchant varchar(100),
    amount decimal(18,2),
    currency varchar(10),
    date datetime,
    status varchar(20),
    foreign key (card_id) references Digital_Banking_Payments.credit_cards(card_id)
);
--8. OnlineBankingUsers

create table Digital_Banking_Payments.online_banking_users (
    user_id int primary key,
    customer_id int,
    username varchar(50),
    password_hash varchar(200),
    last_login datetime,
    foreign key (customer_id) references Core_Banking.customers(customer_id)
);
--9. BillPayments
 
 create table Digital_Banking_Payments.bill_payments (
    payment_id int primary key,
    customer_id int,
    biller_name varchar(100),
    amount decimal(18,2),
    date date,
    status varchar(20),
    foreign key (customer_id) references Core_Banking.customers(customer_id)
);
--10. MobileBankingTransactions

create table Digital_Banking_Payments.mobile_banking_transactions (
    transaction_id int primary key,
    customer_id int,
    device_id varchar(50),
    app_version varchar(20),
    transaction_type varchar(30),
    amount decimal(18,2),
    date datetime,
    foreign key (customer_id) references Core_Banking.customers(customer_id)
);
--🏦 Loans & Credit
--11. Loans

create table Loans_Credit.loans (
    loan_id int primary key,
    customer_id int,
    loan_type varchar(50),
    amount decimal(18,2),
    interest_rate decimal(5,2),
    start_date date,
    end_date date,
    status varchar(20),
    foreign key (customer_id) references Core_Banking.customers(customer_id)
);
--12. LoanPayments

create table Loans_Credit.loan_payments (
    payment_id int primary key,
    loan_id int,
    amount_paid decimal(18,2),
    payment_date date,
    remaining_balance decimal(18,2),
    foreign key (loan_id) references Loans_Credit.loans(loan_id)
);
--13. CreditScores

create table Loans_Credit.credit_scores (
    customer_id int primary key,
    credit_score int,
    updated_at datetime,
    foreign key (customer_id) references Core_Banking.customers(customer_id)
);
--14. DebtCollection

create table Loans_Credit.debt_collection (
    debt_id int primary key,
    customer_id int,
    amount_due decimal(18,2),
    due_date date,
    collector_assigned varchar(100),
    foreign key (customer_id) references Core_Banking.customers(customer_id)
);
--📊 Compliance & Risk
--15. KYC

create table Compliance_Risk.kyc (
    kyc_id int primary key,
    customer_id int,
    document_type varchar(50),
    document_number varchar(50),
    verified_by varchar(100),
    foreign key (customer_id) references Core_Banking.customers(customer_id)
);
--16. FraudDetection

create table Compliance_Risk.fraud_detection (
    fraud_id int primary key,
    customer_id int,
    transaction_id int,
    risk_level varchar(20),
    reported_date date,
    foreign key (customer_id) references Core_Banking.customers(customer_id),
    foreign key (transaction_id) references Core_Banking.transactions(transaction_id)
);
--17. AML Cases

create table Compliance_Risk.aml_cases (
    case_id int primary key,
    customer_id int,
    case_type varchar(50),
    status varchar(20),
    investigator_id int,
    foreign key (customer_id) references Core_Banking.customers(customer_id)
);
--18. RegulatoryReports

create table Compliance_Risk.regulatory_reports (
    report_id int primary key,
    report_type varchar(100),
    submission_date date
);
--🧑‍💼 Human Resources
--19. Departments

create table Human_Resources.departments (
    department_id int primary key,
    department_name varchar(100),
    manager_id int
);
--20. Salaries

create table Human_Resources.salaries (
    salary_id int primary key,
    employee_id int,
    base_salary decimal(18,2),
    bonus decimal(18,2),
    deductions decimal(18,2),
    payment_date date,
    foreign key (employee_id) references Core_Banking.employees(employee_id)
);
--21. EmployeeAttendance

create table Human_Resources.employee_attendance (
    attendance_id int primary key,
    employee_id int,
    check_in_time datetime,
    check_out_time datetime,
    total_hours decimal(5,2),
    foreign key (employee_id) references Core_Banking.employees(employee_id)
);
--📈 Investments & Treasury
--22. Investments
--Investments_Treasury

create table Investments_Treasury.investments (
    investment_id int primary key,
    customer_id int,
    investment_type varchar(50),
    amount decimal(18,2),
    roi decimal(5,2),
    maturity_date date,
    foreign key (customer_id) references Core_Banking.customers(customer_id)
);
--23. StockTradingAccounts

create table Investments_Treasury.stock_trading_accounts (
    account_id int primary key,
    customer_id int,
    brokerage_firm varchar(100),
    total_invested decimal(18,2),
    current_value decimal(18,2),
    foreign key (customer_id) references Core_Banking.customers(customer_id)
);
--24. ForeignExchange

create table Investments_Treasury.foreign_exchange (
    fx_id int primary key,
    customer_id int,
    currency_pair varchar(20),
    exchange_rate decimal(10,4),
    amount_exchanged decimal(18,2),
    foreign key (customer_id) references Core_Banking.customers(customer_id)
);
--📜 Insurance & Security
Insurance_Security
--25. InsurancePolicies

create table Insurance_Security.insurance_policies (
    policy_id int primary key,
    customer_id int,
    insurance_type varchar(50),
    premium_amount decimal(18,2),
    coverage_amount decimal(18,2),
    foreign key (customer_id) references Core_Banking.customers(customer_id)
);
--26. Claims

create table Insurance_Security.claims (
    claim_id int primary key,
    policy_id int,
    claim_amount decimal(18,2),
    status varchar(20),
    filed_date date,
    foreign key (policy_id) references Insurance_Security.insurance_policies(policy_id)
);
--27. UserAccessLogs

create table Insurance_Security.user_access_logs (
    log_id int primary key,
    user_id int,
    action_type varchar(50),
    timestamp datetime
);
--28. CyberSecurityIncidents

create table Insurance_Security.cyber_security_incidents (
    incident_id int primary key,
    affected_system varchar(100),
    reported_date date,
    resolution_status varchar(50)
);
--🛒 Merchant Services
--29. Merchants

create table Merchant_Services.merchants (
    merchant_id int primary key,
    merchant_name varchar(100),
    industry varchar(50),
    location varchar(100),
    customer_id int,
    foreign key (customer_id) references Core_Banking.customers(customer_id)
);
--30. MerchantTransactions

create table Merchant_Services.merchant_transactions (
    transaction_id int primary key,
    merchant_id int,
    amount decimal(18,2),
    payment_method varchar(30),
    date date,
    foreign key (merchant_id) references Merchant_Services.merchants(merchant_id)
);

