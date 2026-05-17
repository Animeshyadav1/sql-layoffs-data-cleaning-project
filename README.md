# 📊 SQL Layoffs Data Cleaning Project

## 📌 Project Overview
This project focuses on cleaning and transforming a real-world layoffs dataset using MySQL.

The raw dataset contained:
- Duplicate records
- Inconsistent formatting
- Missing values
- Unstandardized data

The dataset was cleaned and prepared using SQL queries in MySQL.

---

## 🛠️ Tool Used
- MySQL

---

## 🔍 Data Cleaning Tasks Performed
- Created staging tables for safe data cleaning
- Removed duplicate records using `ROW_NUMBER()`
- Standardized company and industry names
- Trimmed unnecessary spaces using `TRIM()`
- Converted date formats using `STR_TO_DATE()`
- Identified and handled null values
- Used self joins to populate missing industry data

---

## 📚 SQL Concepts Used

```sql
CTE
ROW_NUMBER()
PARTITION BY
JOINS
UPDATE
DELETE
TRIM()
STR_TO_DATE()
WINDOW FUNCTIONS
```

---

## 📂 Project Workflow
1. Imported raw layoffs dataset
2. Created staging tables
3. Identified duplicate records
4. Removed duplicates
5. Standardized text fields
6. Handled missing values
7. Converted date formats
8. Prepared cleaned dataset for analysis

---

## 🎯 Project Objective
The objective of this project was to practice real-world SQL data cleaning techniques commonly used in Data Analyst roles.

---

## 🚀 Learning Source
Inspired by Alex The Analyst SQL Data Cleaning Project.

YouTube Channel:  
https://www.youtube.com/@AlexTheAnalyst

---

## 📁 Project Files
- `layoffs_data_cleaning.sql` → SQL queries used for data cleaning
- `layoffs.csv` → Raw layoffs dataset
- `README.md` → Project documentation

---

## 👨‍💻 Author
Animesh Yadav
