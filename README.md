# Python Pandas Workshop for Business Students

## 🎯 Workshop Overview

This workshop demonstrates how Python with Pandas and NumPy can dramatically simplify data workflows that are traditionally painful in Excel. We'll cover real-world business scenarios and show you how to go from hours of manual work to minutes of automated analysis.

## 📋 What You'll Learn

1. **Data Cleaning** - Handle messy data without manual editing
2. **Data Transformation** - VLOOKUP alternatives that actually scale
3. **Pivot Tables** - More powerful and reproducible analysis
4. **Data Visualization** - Create publication-ready charts
5. **Automation** - Run the same analysis on new data with one command

## 🐳 Getting Started with Docker

### Prerequisites
- Docker Desktop installed on your machine
- No Python installation required!

### Quick Start

```bash
# Clone this repository
git clone https://github.com/Davwed0/test.git
cd test
git checkout python-pandas-workshop

# Start the Jupyter environment
docker-compose up

# Open http://localhost:8888 in your browser
```

## 📁 Repository Structure

```
├── README.md
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── data/
│   └── sales_data.csv
├── notebooks/
│   ├── 01_excel_pain_points.ipynb
│   ├── 02_pandas_solutions.ipynb
│   └── 03_data_visualization.ipynb
└── scripts/
    └── data_pipeline.py
```

## 🔥 Excel Pain Points We'll Solve

| Excel Problem | Pandas Solution |
|---------------|-----------------|
| VLOOKUP breaks with large datasets | `pd.merge()` handles millions of rows |
| Manual copy-paste for data cleaning | `df.apply()` and string methods |
| Pivot tables aren't reproducible | `df.pivot_table()` in code |
| Charts require manual formatting | Matplotlib/Seaborn templates |
| Can't handle files > 1 million rows | Pandas + chunking = unlimited |

## 🚀 Workshop Modules

### Module 1: The Excel Nightmare
See a real-world scenario where Excel falls short with sales data analysis.

### Module 2: Pandas to the Rescue
Learn how to accomplish the same tasks in a fraction of the time.

### Module 3: Beautiful Visualizations
Create charts that would take hours in Excel, in just a few lines of code.

## 📞 Support

Having issues? Open an issue in this repository or reach out during the workshop.

---
*Workshop created for Business Students - Making Data Analysis Accessible*