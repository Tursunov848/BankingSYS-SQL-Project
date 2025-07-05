# 📘 BankingSYS SQL Project Documentation

## 1. Project Overview
**Project Title:** BankingSYS SQL Project  
**Purpose:** Develop a reliable SQL-based BI system for a fictional bank previously reliant on Excel.  

## 2. Team & Roles
- **[You]:** Team leader – management, task division, SPs, documentation  
- **Faxriddin Shukurov:** Data engineering – schemas, tables, data ingestion, views  
- **Oybek:** Power BI dashboard, additional views  

## 3. Tools Used
- **SQL Server** for database development  
- **Python + GPT** for generating realistic synthetic data  
- **Power BI** for dashboarding  
- **ClickUp** for task management  
- **GitHub** for script storage  
- **Telegram** for team communication  

## 4. Architecture
- **Schemas:** 1 Staging schema, 8 Final schemas  
- **Tables:** 30 total  
- **Process:** Raw CSV → Staging Tables → Final Tables → Reporting Views  
- **Keys:** FK/PK enforced in final layer  

## 5. KPIs Implemented
| # | KPI |
|---|-----|
| 1 | Avg Monthly Transactions per Customer |
| 2 | Repeated Failed Card Transactions in 10–15 Minutes |
| 3 | Customers with More Than One Active Loan |
| 4 | Rapid Large Transactions (> $10,000 in <1hr) |
| 5 | Total Loan Amount Issued per Branch |
| 6 | Top 3 Customers with Highest Balance |
| 7 | Fraudulent Transactions |
| 8 | Cross-Country Transactions Within 10 Minutes |

## 6. Stored Procedures
| SP Name | Function |
|---------|----------|
| `sp_GetEmployeeProfile` | HR summary incl. salary & attendance |
| `sp_EvaluateLoanRequest` | Credit score eval + interest calc |
| `sp_GetCustomerFinancialProfile` | Overview of customer’s financial footprint |
| `sp_GetBranchInsights` | Key metrics for a single branch |

## 7. Data Pipeline
- Python generated 30 CSVs  
- Data was imported manually into staging tables  
- Transformed using `SELECT INTO` from staging → final  
- Cleaned & validated manually

## 8. Challenges Faced
- Column/type mismatches during data generation  
- Deciding schema before implementation took time  
- Once tasks were clear, execution was smooth  

## 9. Lessons Learned
- Importance of alignment before development  
- Deep focus on details early saves hours later  
- Breaking work into clear responsibilities accelerates success  

## 10. Timeline
- Project start: 18 June  
- Data ready: 24 June  
- KPIs + SPs: 2 July  
- Final dashboard & docs: 5 July  

## 11. Future Features
*To be updated: credit score modeling, predictive risk scoring, automation via SQL Agent jobs*
