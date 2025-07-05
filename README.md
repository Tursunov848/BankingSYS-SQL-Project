# 🏦 BankingSYS SQL Project

This project simulates a full-scale banking business intelligence system, developed for a fictional bank transitioning from Excel-based data operations to a structured SQL Server data platform. It provides reliable, queryable data models and KPI dashboards for fraud detection, customer insights, and financial operations.

## 📌 Objective

The goal was to replace error-prone Excel sheets with a scalable, maintainable SQL Server-based system. This model provides staging, transformation, and reporting layers, covering customer accounts, transactions, loans, credit scores, fraud, and employee management.

## 👥 Team

- **Team Size:** 3 members  
- **Team Lead:** Abdumannof Tursunov – Task division, team management, documentation, stored procedures  
- **Faxriddin Shukurov:** Schemas, staging/final tables, data generation and ingestion, view creation  
- **Oybek Yo'ldoshev:** Additional views and Power BI dashboard

## 🧰 Tech Stack

- **Database:** SQL Server  
- **Data Generation:** Python + GPT  
- **Visualization:** Power BI  
- **Project Management:** ClickUp, GitHub, Telegram

## 🗂️ Project Architecture

- **Schemas:** 1 Staging Schema + 8 Final Schemas  
- **Tables:** 30 tables in total  
- **Layers:** Staging → Final → Reporting  
- **ETL Process:** Python → CSV → Manual SQL Import → Data Cleaning & Transformation

## 📊 KPIs (Key Performance Indicators)

1. Avg Monthly Transactions per Customer  
2. Repeated Failed Card Transactions in 10–15 Minutes  
3. Customers with More Than One Active Loan  
4. Rapid Large Transactions (> $10,000 within 1 Hour)  
5. Total Loan Amount Issued per Branch  
6. Top 3 Customers with Highest Total Balance  
7. Transactions Flagged as Fraudulent  
8. Cross-Country Transactions Within 10 Minutes *(most complex due to country logic)*

## ⚙️ Stored Procedures

1. `sp_GetEmployeeProfile` – Full HR profile  
2. `sp_EvaluateLoanRequest` – Credit score + decision + loan amount evaluation  
3. `sp_GetCustomerFinancialProfile` – Transactions, accounts, loans, repayment  
4. `sp_GetBranchInsights` – Customer, account, loan, and employee overview per branch

## 📅 Timeline

- **Start Date:** 18 June  
- **Data Modeling & Importing:** by 24 June  
- **KPI Logic & SPs:** by 2 July  
- **Dashboard & Docs:** by 5 July  
- **Final Deadline:** 5 July

## 🚀 Innovation
To be added...
