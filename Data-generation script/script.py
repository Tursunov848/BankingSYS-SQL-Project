##customers_fake_data
import pandas as pd
from faker import Faker
import random
from datetime import datetime

# Fake ma'lumotlar generatori
fake = Faker()

# Nechta yozuv yaratiladi
num_customers = 1000

# Bo'sh ro'yxat
customers_data = []

# Employment status ro'yxati
employment_statuses = ['Employed', 'Unemployed', 'Student', 'Retired', 'Self-Employed']

# Ma'lumotlar yaratish
for i in range(1, num_customers + 1):  # CustomerID: 1 dan 1000 gacha
    full_name = fake.name()
    dob = fake.date_of_birth(minimum_age=18, maximum_age=75)
    email = fake.email()
    phone = fake.phone_number()
    address = fake.address().replace('\n', ', ')
    national_id = fake.unique.random_number(digits=9)
    tax_id = fake.unique.random_number(digits=10)
    employment_status = random.choice(employment_statuses)
    annual_income = round(random.uniform(5000, 150000), 2)
    created_at = fake.date_time_between(start_date='-5y', end_date='-1y')
    updated_at = fake.date_time_between(start_date=created_at, end_date='now')

    customers_data.append({
        "CustomerID": i,
        "FullName": full_name,
        "DOB": dob.strftime('%Y-%m-%d'),
        "Email": email,
        "PhoneNumber": phone,
        "Address": address,
        "NationalID": national_id,
        "TaxID": tax_id,
        "EmploymentStatus": employment_status,
        "AnnualIncome": annual_income,
        "CreatedAt": created_at.strftime('%Y-%m-%d %H:%M:%S'),
        "UpdatedAt": updated_at.strftime('%Y-%m-%d %H:%M:%S')
    })

# DataFrame yaratish
df_customers = pd.DataFrame(customers_data)

# CSV faylga yozish
df_customers.to_csv("customers_fake_data.csv", index=False)

print("✅ 1 dan 1000 gacha bo'lgan 'CustomerID' bilan ma'lumotlar 'customers_fake_data.csv' fayliga saqlandi.")
##Account
import pandas as pd
from faker import Faker
import random
from datetime import datetime

# Faylga ulang: Customers fayli kerak bo'ladi
customers_df = pd.read_csv("customers_fake_data.csv")  # FK: CustomerID
customer_ids = customers_df["CustomerID"].tolist()

# Fake generator
fake = Faker()

# BranchIDlar ro'yxati (misol uchun 10 ta filial)
branch_ids = list(range(1, 11))

# Account turi, valyuta, holati
account_types = ['Savings', 'Checking', 'Business', 'Joint']
currencies = ['USD', 'EUR', 'UZS', 'GBP']
status_types = ['Active', 'Inactive', 'Closed']

# Nechta account (bir foydalanuvchida 1-3 ta bo'lishi mumkin)
accounts_data = []
account_id = 1

for customer_id in customer_ids:
    num_accounts = random.randint(1, 3)  # Har bir mijozga 1-3 ta hisob
    for _ in range(num_accounts):
        account_type = random.choice(account_types)
        balance = round(random.uniform(0, 100000), 2)
        currency = random.choice(currencies)
        status = random.choice(status_types)
        branch_id = random.choice(branch_ids)
        created_date = fake.date_between(start_date='-5y', end_date='today')

        accounts_data.append({
            "AccountID": account_id,
            "CustomerID": customer_id,
            "AccountType": account_type,
            "Balance": balance,
            "Currency": currency,
            "Status": status,
            "BranchID": branch_id,
            "CreatedDate": created_date.strftime('%Y-%m-%d')
        })

        account_id += 1

# DataFrame yaratish
df_accounts = pd.DataFrame(accounts_data)

# CSV faylga saqlash
df_accounts.to_csv("accounts_fake_data.csv", index=False)

print(f"✅ {len(df_accounts)} ta Account yozuvlari 'accounts_fake_data.csv' fayliga saqlandi.")
##Transactions
import pandas as pd
from faker import Faker
import random
from datetime import datetime

# Avval account faylidan AccountID larni o'qiymiz (FK uchun)
accounts_df = pd.read_csv("accounts_fake_data.csv")
account_ids = accounts_df["AccountID"].tolist()

# Faker instance
fake = Faker()

# Parametrlar
transaction_types = ['Deposit', 'Withdrawal', 'Transfer', 'Payment']
status_types = ['Completed', 'Pending', 'Failed']
currencies = ['USD', 'EUR', 'UZS', 'GBP']



###loans_fake_data
import pandas as pd
from faker import Faker
import random
from datetime import datetime, timedelta

# FK uchun customers faylidan IDlar
customers_df = pd.read_csv("customers_fake_data.csv")
customer_ids = customers_df["CustomerID"].tolist()

# Faker instance
fake = Faker()

# Parametrlar
loan_types = ['Mortgage', 'Personal', 'Auto', 'Business']
loan_statuses = ['Approved', 'Rejected', 'Ongoing', 'Closed']

loans_data = []
loan_id = 1

for customer_id in customer_ids:
    num_loans = random.randint(0, 2)  # Har bir mijozga 0-2 ta kredit
    for _ in range(num_loans):
        loan_type = random.choice(loan_types)
        amount = round(random.uniform(1000, 500000), 2)
        interest_rate = round(random.uniform(3.0, 15.0), 2)
        start_date = fake.date_between(start_date='-5y', end_date='-6m')
        loan_term_years = random.randint(1, 10)
        end_date = start_date + timedelta(days=loan_term_years * 365)
        status = random.choice(loan_statuses)

        loans_data.append({
            "LoanID": loan_id,
            "CustomerID": customer_id,
            "LoanType": loan_type,
            "Amount": amount,
            "InterestRate": interest_rate,
            "StartDate": start_date.strftime('%Y-%m-%d'),
            "EndDate": end_date.strftime('%Y-%m-%d'),
            "Status": status
        })

        loan_id += 1

# DataFramega o‘tkazish
df_loans = pd.DataFrame(loans_data)

# CSV faylga yozish
df_loans.to_csv("loans_fake_data.csv", index=False)

print(f"✅ {len(df_loans)} ta 'Loans' yozuvi 'loans_fake_data.csv' fayliga saqlandi.")




###loan_payments_fake_data
import pandas as pd
from faker import Faker
import random
from datetime import datetime, timedelta

# FK uchun LoanID larni yuklaymiz
loans_df = pd.read_csv("loans_fake_data.csv")
loan_ids = loans_df["LoanID"].tolist()

# LoanID bilan bog‘liq barcha loan ma’lumotlarini lug‘atda saqlaymiz
loan_info = loans_df.set_index("LoanID").to_dict(orient="index")

# Faker generator
fake = Faker()

# Payment yozuvlari
loan_payments = []
payment_id = 1

for loan_id in loan_ids:
    loan = loan_info[loan_id]
    loan_amount = loan["Amount"]
    start_date = datetime.strptime(loan["StartDate"], "%Y-%m-%d")
    end_date = datetime.strptime(loan["EndDate"], "%Y-%m-%d")

    # Har bir kredit uchun 3–10 ta to‘lov bo‘lsin
    num_payments = random.randint(3, 10)
    remaining_balance = loan_amount
    payment_dates = sorted([fake.date_between(start_date=start_date, end_date=end_date) for _ in range(num_payments)])

    for i in range(num_payments):
        if remaining_balance <= 0:
            break

        amount_paid = round(random.uniform(remaining_balance * 0.05, remaining_balance * 0.3), 2)
        amount_paid = min(amount_paid, remaining_balance)  # ortiqcha to'lov bo'lmasin
        remaining_balance = round(remaining_balance - amount_paid, 2)

        loan_payments.append({
            "PaymentID": payment_id,
            "LoanID": loan_id,
            "AmountPaid": amount_paid,
            "PaymentDate": payment_dates[i].strftime('%Y-%m-%d'),
            "RemainingBalance": remaining_balance
        })

        payment_id += 1

# DataFramega o‘tkazish
df_loan_payments = pd.DataFrame(loan_payments)

# CSV faylga yozish
df_loan_payments.to_csv("loan_payments_fake_data.csv", index=False)

print(f"✅ {len(df_loan_payments)} ta 'LoanPayments' yozuvi 'loan_payments_fake_data.csv' fayliga saqlandi.")





###credit_scores_fake_data
import pandas as pd
from faker import Faker
import random

# FK uchun customers faylidan IDlar
customers_df = pd.read_csv("customers_fake_data.csv")
customer_ids = customers_df["CustomerID"].tolist()

# Faker generator
fake = Faker()

# Credit score ma'lumotlari
credit_scores = []

for customer_id in customer_ids:
    credit_score = random.randint(300, 850)
    updated_at = fake.date_time_between(start_date='-1y', end_date='now')

    credit_scores.append({
        "CustomerID": customer_id,
        "CreditScore": credit_score,
        "UpdatedAt": updated_at.strftime('%Y-%m-%d %H:%M:%S')
    })

# DataFrame yaratish
df_credit_scores = pd.DataFrame(credit_scores)

# CSVga yozish
df_credit_scores.to_csv("credit_scores_fake_data.csv", index=False)

print(f"✅ {len(df_credit_scores)} ta 'CreditScores' yozuvi 'credit_scores_fake_data.csv' fayliga saqlandi.")



###debt_collection_fake_data
import pandas as pd
from faker import Faker
import random
from datetime import datetime, timedelta

# FK uchun customers faylidan IDlar
customers_df = pd.read_csv("customers_fake_data.csv")
customer_ids = customers_df["CustomerID"].tolist()

# Fake generator
fake = Faker()

# Collector xodimlar nomlari (yoki bo‘limlar)
collector_names = ['DebtCorp', 'FastCollect', 'UzDebtRecovery', 'FinanceControl', 'TrustAgency']

debt_data = []
debt_id = 1

for customer_id in customer_ids:
    # 15–25% mijozlar qarzdor bo‘lishi mumkin
    if random.random() < 0.2:
        amount_due = round(random.uniform(100, 20000), 2)
        due_date = fake.date_between(start_date='-1y', end_date='+2M')
        collector = random.choice(collector_names)

        debt_data.append({
            "DebtID": debt_id,
            "CustomerID": customer_id,
            "AmountDue": amount_due,
            "DueDate": due_date.strftime('%Y-%m-%d'),
            "CollectorAssigned": collector
        })

        debt_id += 1

# DataFramega o‘tkazish
df_debt = pd.DataFrame(debt_data)

# CSVga yozish
df_debt.to_csv("debt_collection_fake_data.csv", index=False)

print(f"✅ {len(df_debt)} ta 'DebtCollection' yozuvi 'debt_collection_fake_data.csv' fayliga saqlandi.")



###kyc_fake_data
import pandas as pd
from faker import Faker
import random

# FK uchun CustomerID larni yuklab olamiz
customers_df = pd.read_csv("customers_fake_data.csv")
customer_ids = customers_df["CustomerID"].tolist()

# Fake generator
fake = Faker()

document_types = ['Passport', 'IDCard', 'DriverLicense', 'ResidencePermit']
verifiers = ['Agent001', 'ComplianceBot', 'KYCAdmin', 'RegTechX', 'SecureScan']

kyc_data = []
kyc_id = 1

for customer_id in customer_ids:
    # 90–100% mijozlar KYC jarayonidan o‘tgan bo'lishi mumkin
    if random.random() < 0.95:
        doc_type = random.choice(document_types)
        doc_number = fake.unique.bothify(text='??######')  # Masalan: AB123456
        verified_by = random.choice(verifiers)

        kyc_data.append({
            "KYCID": kyc_id,
            "CustomerID": customer_id,
            "DocumentType": doc_type,
            "DocumentNumber": doc_number,
            "VerifiedBy": verified_by
        })

        kyc_id += 1

# DataFramega o‘tkazish
df_kyc = pd.DataFrame(kyc_data)

# CSV faylga yozish
df_kyc.to_csv("kyc_fake_data.csv", index=False)

print(f"✅ {len(df_kyc)} ta 'KYC' yozuvi 'kyc_fake_data.csv' fayliga saqlandi.")



###fraud_detection_fake_data
import pandas as pd
from faker import Faker
import random
from datetime import datetime

# CSV fayllardan CustomerID va TransactionID larni yuklash
customers_df = pd.read_csv("customers_fake_data.csv")
transactions_df = pd.read_csv("transactions_fake_data.csv")  # bu faylni ilgari yaratgan bo'lishingiz kerak

customer_ids = customers_df["CustomerID"].tolist()
transaction_ids = transactions_df["TransactionID"].tolist()
transaction_customer_map = transactions_df.set_index("TransactionID")["AccountID"].to_dict()

# Agar AccountID bilan CustomerID bog‘langan bo‘lsa, real mappingni yaratish mumkin.
# Bu holda to‘liq bog‘lanishni hisobga olish kerak.

# Faker init
fake = Faker()

# Parametrlar
risk_levels = ['Low', 'Medium', 'High', 'Critical']
fraud_data = []
fraud_id = 1

# 2–5% tranzaksiyalarda fraud bo‘lishi ehtimoli bor
fraud_txn_sample = random.sample(transaction_ids, int(len(transaction_ids) * 0.04))

for txn_id in fraud_txn_sample:
    risk = random.choice(risk_levels)
    reported_date = fake.date_time_between(start_date='-1y', end_date='now')

    # AccountID orqali CustomerID topishga urinamiz
    try:
        account_id = transaction_customer_map[txn_id]
        # Agar sizda Accounts jadvalidan AccountID → CustomerID mapping bo‘lsa, shu yerda o‘rnating
        account_df = pd.read_csv("accounts_fake_data.csv")
        acc_map = account_df.set_index("AccountID")["CustomerID"].to_dict()
        customer_id = acc_map.get(account_id, random.choice(customer_ids))
    except:
        customer_id = random.choice(customer_ids)

    fraud_data.append({
        "FraudID": fraud_id,
        "CustomerID": customer_id,
        "TransactionID": txn_id,
        "RiskLevel": risk,
        "ReportedDate": reported_date.strftime('%Y-%m-%d %H:%M:%S')
    })

    fraud_id += 1

# DataFrame yaratish
df_fraud = pd.DataFrame(fraud_data)

# CSV faylga yozish
df_fraud.to_csv("fraud_detection_fake_data.csv", index=False)

print(f"✅ {len(df_fraud)} ta 'FraudDetection' yozuvi 'fraud_detection_fake_data.csv' fayliga saqlandi.")


##aml_cases_fake_data
import pandas as pd
from faker import Faker
import random
from datetime import datetime

# FK uchun customers faylidan IDlar
customers_df = pd.read_csv("customers_fake_data.csv")
customer_ids = customers_df["CustomerID"].tolist()

# Faker generator
fake = Faker()

# CaseType va Status qiymatlari
case_types = ['Structuring', 'SuspiciousTransfer', 'LargeCash', 'International', 'ShellAccount']
status_list = ['Open', 'Investigating', 'Escalated', 'Closed']
investigator_ids = ['AML001', 'AML002', 'INV_A', 'TeamX', 'Compliance77']

# AML case yozuvlari
aml_cases = []
case_id = 1

# 2–5% mijozlar AML monitoringiga tushgan bo‘lishi mumkin
sample_customers = random.sample(customer_ids, int(len(customer_ids) * 0.04))

for customer_id in sample_customers:
    num_cases = random.randint(1, 2)  # Har mijozda 1 yoki 2 ta case bo‘lishi mumkin
    for _ in range(num_cases):
        case_type = random.choice(case_types)
        status = random.choice(status_list)
        investigator = random.choice(investigator_ids)

        aml_cases.append({
            "CaseID": case_id,
            "CustomerID": customer_id,
            "CaseType": case_type,
            "Status": status,
            "InvestigatorID": investigator
        })

        case_id += 1

# DataFrame yaratish
df_aml = pd.DataFrame(aml_cases)

# CSVga yozish
df_aml.to_csv("aml_cases_fake_data.csv", index=False)

print(f"✅ {len(df_aml)} ta 'AML' yozuvi 'aml_cases_fake_data.csv' fayliga saqlandi.")




##regulatory_reports_fake_data
import pandas as pd
from faker import Faker
import random
from datetime import datetime

# Faker generator
fake = Faker()

report_types = [
    'FinancialStatement',
    'AMLReport',
    'TaxReport',
    'CustomerReport',
    'RiskAssessment'
]

reports = []
report_id = 1

# Har bir turdagi hisobotdan bir nechtasi bo‘ladi
for report_type in report_types:
    num_reports = random.randint(3, 6)  # Har bir report turidan 3-6 dona
    for _ in range(num_reports):
        submission_date = fake.date_between(start_date='-3y', end_date='today')

        reports.append({
            "ReportID": report_id,
            "ReportType": report_type,
            "SubmissionDate": submission_date.strftime('%Y-%m-%d')
        })

        report_id += 1

# DataFrame yaratish
df_reports = pd.DataFrame(reports)

# CSV faylga yozish
df_reports.to_csv("regulatory_reports_fake_data.csv", index=False)

print(f"✅ {len(df_reports)} ta 'RegulatoryReports' yozuvi 'regulatory_reports_fake_data.csv' fayliga saqlandi.")


###departments_fake_data
import pandas as pd
from faker import Faker
import random

# FK uchun EmployeeID larni yuklab olamiz
employees_df = pd.read_csv("employees_fake_data.csv")
employee_ids = employees_df["EmployeeID"].tolist()

# Faker init
fake = Faker()

# Realistik department nomlari
department_names = [
    "Finance", "Operations", "Retail Banking", "Risk Management",
    "Compliance", "IT", "HR", "Legal", "Treasury", "Digital Banking"
]

departments = []
department_ids = list(range(1, len(department_names) + 1))

for i, dept_name in zip(department_ids, department_names):
    manager_id = random.choice(employee_ids)

    departments.append({
        "DepartmentID": i,
        "DepartmentName": dept_name,
        "ManagerID": manager_id
    })

# DataFrame yaratish
df_departments = pd.DataFrame(departments)

# CSVga yozish
df_departments.to_csv("departments_fake_data.csv", index=False)

print(f"✅ {len(df_departments)} ta 'Departments' yozuvi 'departments_fake_data.csv' fayliga saqlandi.")



####salaries_fake_data
import pandas as pd
from faker import Faker
import random

# FK uchun EmployeeID larni yuklab olamiz
employees_df = pd.read_csv("employees_fake_data.csv")
employee_ids = employees_df["EmployeeID"].tolist()

# Faker generator
fake = Faker()

# Ma'lumotlar ro'yxati
salaries_data = []
salary_id = 1

for emp_id in employee_ids:
    num_payments = random.randint(3, 6)  # Har bir xodim uchun 3–6 ta oylik to'lov
    payment_dates = [fake.date_between(start_date='-6M', end_date='today') for _ in range(num_payments)]
    payment_dates.sort()

    for pay_date in payment_dates:
        base_salary = round(random.uniform(800, 5000), 2)
        bonus = round(random.uniform(0, base_salary * 0.2), 2)
        deductions = round(random.uniform(0, base_salary * 0.1), 2)

        salaries_data.append({
            "SalaryID": salary_id,
            "EmployeeID": emp_id,
            "BaseSalary": base_salary,
            "Bonus": bonus,
            "Deductions": deductions,
            "PaymentDate": pay_date.strftime('%Y-%m-%d')
        })

        salary_id += 1

# DataFrame yaratish
df_salaries = pd.DataFrame(salaries_data)

# CSVga yozish
df_salaries.to_csv("salaries_fake_data.csv", index=False)

print(f"✅ {len(df_salaries)} ta 'Salaries' yozuvi 'salaries_fake_data.csv' fayliga saqlandi.")


###employee_attendance_fake_data
import pandas as pd
from faker import Faker
import random
from datetime import datetime, timedelta

# FK uchun employee ID larni yuklab olamiz
employees_df = pd.read_csv("employees_fake_data.csv")
employee_ids = employees_df["EmployeeID"].tolist()

# Faker init
fake = Faker()

attendance_data = []
attendance_id = 1

for emp_id in employee_ids:
    # Har bir xodim uchun 5-10 ish kuni bo‘lsin
    num_days = random.randint(5, 10)
    work_days = [fake.date_between(start_date='-2M', end_date='today') for _ in range(num_days)]
    work_days.sort()

    for work_day in work_days:
        # Check-in va check-out vaqtlar
        check_in = datetime.combine(work_day, fake.time_object(end_datetime=None)).replace(hour=8, minute=random.randint(0, 30))
        check_out = check_in + timedelta(hours=8, minutes=random.randint(0, 45))  # 8 soat +/-

        total_hours = round((check_out - check_in).total_seconds() / 3600, 2)

        attendance_data.append({
            "AttendanceID": attendance_id,
            "EmployeeID": emp_id,
            "CheckInTime": check_in.strftime('%Y-%m-%d %H:%M:%S'),
            "CheckOutTime": check_out.strftime('%Y-%m-%d %H:%M:%S'),
            "TotalHours": total_hours
        })

        attendance_id += 1

# DataFramega o‘tkazish
df_attendance = pd.DataFrame(attendance_data)

# CSVga yozish
df_attendance.to_csv("employee_attendance_fake_data.csv", index=False)

print(f"✅ {len(df_attendance)} ta 'EmployeeAttendance' yozuvi 'employee_attendance_fake_data.csv' fayliga saqlandi.")



###investments_fake_data
import pandas as pd
from faker import Faker
import random
from datetime import datetime, timedelta

# FK uchun customer ID larni yuklab olamiz
customers_df = pd.read_csv("customers_fake_data.csv")
customer_ids = customers_df["CustomerID"].tolist()

# Faker init
fake = Faker()

investment_types = ['Stocks', 'Bonds', 'MutualFunds', 'RealEstate', 'Crypto']

investments_data = []
investment_id = 1

# 20-30% mijozlarda investitsiya mavjud bo‘ladi
sample_customers = random.sample(customer_ids, int(len(customer_ids) * 0.25))

for customer_id in sample_customers:
    # Har bir mijozga 1–3 ta investitsiya yozuvi
    num_investments = random.randint(1, 3)
    for _ in range(num_investments):
        inv_type = random.choice(investment_types)
        amount = round(random.uniform(500, 100000), 2)
        roi = round(random.uniform(-10, 20), 2)  # -10% (yo‘qotish) dan +20% gacha
        maturity_date = fake.date_between(start_date='+3M', end_date='+5y')

        investments_data.append({
            "InvestmentID": investment_id,
            "CustomerID": customer_id,
            "InvestmentType": inv_type,
            "Amount": amount,
            "ROI": roi,
            "MaturityDate": maturity_date.strftime('%Y-%m-%d')
        })

        investment_id += 1

# DataFramega o‘tkazish
df_investments = pd.DataFrame(investments_data)

# CSVga yozish
df_investments.to_csv("investments_fake_data.csv", index=False)

print(f"✅ {len(df_investments)} ta 'Investments' yozuvi 'investments_fake_data.csv' fayliga saqlandi.")


###stock_trading_accounts_fake_data
import pandas as pd
from faker import Faker
import random

# FK uchun CustomerID larni yuklab olamiz
customers_df = pd.read_csv("customers_fake_data.csv")
customer_ids = customers_df["CustomerID"].tolist()

# Fake generator
fake = Faker()

brokerage_firms = ['eToro', 'Tinkoff', 'Interactive Brokers', 'Freedom Finance', 'Robinhood', 'Saxo Bank']

trading_accounts = []
account_id = 1

# 10–20% mijozlar stock trading account ochgan bo'lishi mumkin
sample_customers = random.sample(customer_ids, int(len(customer_ids) * 0.15))

for customer_id in sample_customers:
    num_accounts = random.randint(1, 2)  # Ba'zilar 2 ta hisob ochgan bo'lishi mumkin
    for _ in range(num_accounts):
        brokerage = random.choice(brokerage_firms)
        total_invested = round(random.uniform(1000, 100000), 2)
        current_value = round(total_invested * random.uniform(0.85, 1.5), 2)  # ROI ga qarab oshgan yoki kamaygan

        trading_accounts.append({
            "AccountID": account_id,
            "CustomerID": customer_id,
            "BrokerageFirm": brokerage,
            "TotalInvested": total_invested,
            "CurrentValue": current_value
        })

        account_id += 1

# DataFramega o‘tkazish
df_trading = pd.DataFrame(trading_accounts)

# CSVga yozish
df_trading.to_csv("stock_trading_accounts_fake_data.csv", index=False)

print(f"✅ {len(df_trading)} ta 'StockTradingAccounts' yozuvi 'stock_trading_accounts_fake_data.csv' fayliga saqlandi.")



###ForeignExchange
import pandas as pd
from faker import Faker
import random

# FK uchun customers faylidan ID larni yuklab olamiz
customers_df = pd.read_csv("customers_fake_data.csv")
customer_ids = customers_df["CustomerID"].tolist()

# Faker init
fake = Faker()

currency_pairs = [
    'USD/EUR', 'EUR/GBP', 'USD/JPY', 'GBP/USD', 'AUD/USD',
    'USD/CHF', 'USD/CAD', 'EUR/JPY', 'NZD/USD', 'USD/CNY'
]

fx_data = []
fx_id = 1

# 15–25% mijozlar valyuta ayirboshlash operatsiyasida qatnashgan bo'lishi mumkin
sample_customers = random.sample(customer_ids, int(len(customer_ids) * 0.2))

for customer_id in sample_customers:
    num_fx_ops = random.randint(1, 3)
    for _ in range(num_fx_ops):
        pair = random.choice(currency_pairs)
        exchange_rate = round(random.uniform(0.5, 1.5), 4)
        amount_exchanged = round(random.uniform(100, 10000), 2)

        fx_data.append({
            "FXID": fx_id,
            "CustomerID": customer_id,
            "CurrencyPair": pair,
            "ExchangeRate": exchange_rate,
            "AmountExchanged": amount_exchanged
        })

        fx_id += 1

# DataFrame yaratish
df_fx = pd.DataFrame(fx_data)

# CSV faylga yozish
df_fx.to_csv("foreign_exchange_fake_data.csv", index=False)

print(f"✅ {len(df_fx)} ta 'ForeignExchange' yozuvi 'foreign_exchange_fake_data.csv' fayliga saqlandi.")


###insurance_policies_fake_data
import pandas as pd
from faker import Faker
import random

# FK uchun customers faylidan ID larni yuklab olamiz
customers_df = pd.read_csv("customers_fake_data.csv")
customer_ids = customers_df["CustomerID"].tolist()

# Faker init
fake = Faker()

insurance_types = ['Health', 'Life', 'Vehicle', 'Property', 'Travel']

insurance_data = []
policy_id = 1

# 15–25% mijozlarda sug'urta mavjud bo'lishi mumkin
sample_customers = random.sample(customer_ids, int(len(customer_ids) * 0.2))

for customer_id in sample_customers:
    num_policies = random.randint(1, 2)  # Ba'zi mijozlarda 2 ta polis bo'lishi mumkin
    for _ in range(num_policies):
        policy_type = random.choice(insurance_types)
        premium = round(random.uniform(100, 2000), 2)
        coverage = round(premium * random.uniform(10, 30), 2)  # Sug'urta qoplamasi ko'proq bo'ladi

        insurance_data.append({
            "PolicyID": policy_id,
            "CustomerID": customer_id,
            "InsuranceType": policy_type,
            "PremiumAmount": premium,
            "CoverageAmount": coverage
        })

        policy_id += 1

# DataFramega o‘tkazish
df_insurance = pd.DataFrame(insurance_data)

# CSVga yozish
df_insurance.to_csv("insurance_policies_fake_data.csv", index=False)

print(f"✅ {len(df_insurance)} ta 'InsurancePolicies' yozuvi 'insurance_policies_fake_data.csv' fayliga saqlandi.")



###claims_fake_data
import pandas as pd
from faker import Faker
import random

# FK uchun policy ID larni yuklab olamiz
insurance_df = pd.read_csv("insurance_policies_fake_data.csv")
policy_ids = insurance_df["PolicyID"].tolist()

# Faker init
fake = Faker()

statuses = ['Filed', 'UnderReview', 'Approved', 'Rejected', 'Settled']

claims_data = []
claim_id = 1

# 40–60% sug'urta polislariga da'vo berilgan bo'lishi mumkin
sample_policies = random.sample(policy_ids, int(len(policy_ids) * 0.5))

for policy_id in sample_policies:
    num_claims = random.randint(1, 2)  # Har bir polisda 1-2 da'vo bo'lishi mumkin
    for _ in range(num_claims):
        claim_amount = round(random.uniform(200, 5000), 2)
        status = random.choice(statuses)
        filed_date = fake.date_between(start_date='-2y', end_date='today')

        claims_data.append({
            "ClaimID": claim_id,
            "PolicyID": policy_id,
            "ClaimAmount": claim_amount,
            "Status": status,
            "FiledDate": filed_date.strftime('%Y-%m-%d')
        })

        claim_id += 1

# DataFramega o‘tkazish
df_claims = pd.DataFrame(claims_data)

# CSVga yozish
df_claims.to_csv("claims_fake_data.csv", index=False)

print(f"✅ {len(df_claims)} ta 'Claims' yozuvi 'claims_fake_data.csv' fayliga saqlandi.")



####user_access_logs_fake_data
import pandas as pd
from faker import Faker
import random
from datetime import datetime, timedelta

# FK uchun OnlineBankingUsers jadvalidan UserID larni yuklab olamiz
users_df = pd.read_csv("online_banking_users_fake_data.csv")
user_ids = users_df["UserID"].tolist()

# Faker init
fake = Faker()

action_types = ['Login', 'Logout', 'PasswordChange', 'FailedLogin', 'SessionTimeout']

logs_data = []
log_id = 1

# Har bir foydalanuvchi uchun 5–10 ta log yozuvi
for user_id in user_ids:
    num_logs = random.randint(5, 10)
    for _ in range(num_logs):
        action = random.choice(action_types)
        timestamp = fake.date_time_between(start_date='-6M', end_date='now')

        logs_data.append({
            "LogID": log_id,
            "UserID": user_id,
            "ActionType": action,
            "Timestamp": timestamp.strftime('%Y-%m-%d %H:%M:%S')
        })

        log_id += 1

# DataFramega o‘tkazish
df_logs = pd.DataFrame(logs_data)

# CSV faylga yozish
df_logs.to_csv("user_access_logs_fake_data.csv", index=False)

print(f"✅ {len(df_logs)} ta 'UserAccessLogs' yozuvi 'user_access_logs_fake_data.csv' fayliga saqlandi.")



#####cybersecurity_incidents_fake_data
import pandas as pd
from faker import Faker
import random

# Faker generator
fake = Faker()

# Affected systems va statuslar
systems = ['OnlineBanking', 'MobileApp', 'CoreBanking', 'ATMNetwork', 'Website', 'InternalNetwork']
statuses = ['Open', 'Investigating', 'Resolved', 'Escalated', 'Closed']

incidents_data = []
incident_id = 1

# 100 dan 200 gacha xavfsizlik hodisasi
num_incidents = random.randint(100, 200)

for _ in range(num_incidents):
    affected_system = random.choice(systems)
    reported_date = fake.date_between(start_date='-1y', end_date='today')
    resolution_status = random.choice(statuses)

    incidents_data.append({
        "IncidentID": incident_id,
        "AffectedSystem": affected_system,
        "ReportedDate": reported_date.strftime('%Y-%m-%d'),
        "ResolutionStatus": resolution_status
    })

    incident_id += 1

# DataFramega o‘tkazish
df_incidents = pd.DataFrame(incidents_data)

# CSV faylga yozish
df_incidents.to_csv("cybersecurity_incidents_fake_data.csv", index=False)

print(f"✅ {len(df_incidents)} ta 'CyberSecurityIncidents' yozuvi 'cybersecurity_incidents_fake_data.csv' fayliga saqlandi.")


####Merchants
import pandas as pd
from faker import Faker
import random

# FK uchun CustomerID larni yuklab olamiz
customers_df = pd.read_csv("customers_fake_data.csv")
customer_ids = customers_df["CustomerID"].tolist()

# Faker init
fake = Faker()

industries = [
    "Retail", "E-commerce", "Healthcare", "Travel", "Finance",
    "Food & Beverage", "Telecom", "Logistics", "Entertainment", "Technology"
]

merchant_data = []
merchant_id = 1

# 200 tagacha merchant yaratiladi, har birining CustomerID bo‘ladi
num_merchants = 200
sample_customers = random.sample(customer_ids, num_merchants)

for customer_id in sample_customers:
    merchant_name = fake.company()
    industry = random.choice(industries)
    location = f"{fake.city()}, {fake.country()}"

    merchant_data.append({
        "MerchantID": merchant_id,
        "MerchantName": merchant_name,
        "Industry": industry,
        "Location": location,
        "CustomerID": customer_id  # FK: Customers jadvalidan
    })

    merchant_id += 1

# DataFramega o‘tkazish
df_merchants = pd.DataFrame(merchant_data)

# CSVga yozish
df_merchants.to_csv("merchants_fake_data.csv", index=False)

print(f"✅ {len(df_merchants)} ta 'Merchants' yozuvi 'merchants_fake_data.csv' fayliga saqlandi.")


# Nechta transaction
num_transactions = 5000

transactions_data = []

for txn_id in range(1, num_transactions + 1):
    account_id = random.choice(account_ids)  # FK mos account
    txn_type = random.choice(transaction_types)
    amount = round(random.uniform(10, 10000), 2)
    currency = random.choice(currencies)
    txn_date = fake.date_time_between(start_date='-3y', end_date='now')
    status = random.choice(status_types)
    reference_no = fake.unique.bothify(text='TXN#######')

    transactions_data.append({
        "TransactionID": txn_id,
        "AccountID": account_id,
        "TransactionType": txn_type,
        "Amount": amount,
        "Currency": currency,
        "Date": txn_date.strftime('%Y-%m-%d %H:%M:%S'),
        "Status": status,
        "ReferenceNo": reference_no
    })

# DataFrame yaratish
df_transactions = pd.DataFrame(transactions_data)

# CSV faylga yozish
df_transactions.to_csv("transactions_fake_data.csv", index=False)

print(f"✅ {num_transactions} ta 'Transactions' yozuvi 'transactions_fake_data.csv' fayliga saqlandi.")
##branches_fake_data
import pandas as pd
from faker import Faker

fake = Faker()
num_branches = 20
branches_data = []

for branch_id in range(1, num_branches + 1):
    branch_name = f"{fake.city()} Branch"
    address = fake.address().replace('\n', ', ')
    city = fake.city()
    state = fake.state()
    country = fake.country()
    contact_number = fake.phone_number()
    
    manager_id = None  # To‘g‘rilanishi keyin
    branches_data.append({
        "BranchID": branch_id,
        "BranchName": branch_name,
        "Address": address,
        "City": city,
        "State": state,
        "Country": country,
        "ManagerID": manager_id,
        "ContactNumber": contact_number
    })

df_branches = pd.DataFrame(branches_data)
df_branches.to_csv("branches_fake_data.csv", index=False)

print("✅ 'branches_fake_data.csv' fayli yaratildi.")


##MerchantTransactions 
import pandas as pd
from faker import Faker
import random

# FK uchun MerchantID larni yuklab olamiz
merchants_df = pd.read_csv("merchants_fake_data.csv")
merchant_ids = merchants_df["MerchantID"].tolist()

# Faker init
fake = Faker()

payment_methods = ['Card', 'BankTransfer', 'MobilePay', 'QRPay', 'Crypto']

transactions_data = []
transaction_id = 1

# Har bir merchant uchun 5–15 ta tranzaksiya yozuvi
for merchant_id in merchant_ids:
    num_txns = random.randint(5, 15)
    for _ in range(num_txns):
        amount = round(random.uniform(5.0, 10000.0), 2)
        payment_method = random.choice(payment_methods)
        txn_date = fake.date_between(start_date='-6M', end_date='today')

        transactions_data.append({
            "TransactionID": transaction_id,
            "MerchantID": merchant_id,
            "Amount": amount,
            "PaymentMethod": payment_method,
            "Date": txn_date.strftime('%Y-%m-%d')
        })

        transaction_id += 1

# DataFramega o‘tkazish
df_merchant_txns = pd.DataFrame(transactions_data)

# CSVga yozish
df_merchant_txns.to_csv("merchant_transactions_fake_data.csv", index=False)

print(f"✅ {len(df_merchant_txns)} ta 'MerchantTransactions' yozuvi 'merchant_transactions_fake_data.csv' fayliga saqlandi.")
