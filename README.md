# Python Pandas Workshop for Business Students

## 🎯 Workshop Overview

This workshop demonstrates how Python (with Pandas & NumPy) can dramatically simplify data workflows that are typically painful in Excel. We'll cover real-world business scenarios and show you how to automate repetitive tasks, handle large datasets, and create stunning visualizations.

## 📊 What You'll Learn

| Excel Pain Point | Python Solution |
|------------------|-----------------|
| VLOOKUP nightmares | Simple `merge()` operations |
| Slow with large files (100k+ rows) | Handle millions of rows effortlessly |
| Manual copy-paste between sheets | Automated data pipelines |
| Complex nested IF formulas | Clean, readable Python logic |
| Pivot table limitations | Flexible `groupby()` aggregations |
| Chart formatting struggles | Beautiful visualizations with matplotlib/seaborn |

## 🐳 Getting Started with Docker

### Prerequisites
- Docker Desktop installed ([Download here](https://www.docker.com/products/docker-desktop))
- No Python installation required!

### Quick Start

```bash
# Clone this repository
git clone https://github.com/Davwed0/test.git
cd test
git checkout python-pandas-workshop

# Start the Jupyter environment
docker-compose up --build

# Open your browser to http://localhost:8888
```

## 📁 Repository Structure

```
├── Dockerfile                 # Python environment setup
├── docker-compose.yml         # Container orchestration
├── requirements.txt           # Python dependencies
├── data/
│   └── sample_sales_data.csv  # Sample dataset
├── notebooks/
│   ├── 01_excel_vs_pandas.ipynb    # Main comparison notebook
│   ├── 02_data_cleaning.ipynb      # Data cleaning techniques
│   └── 03_visualization.ipynb      # Data visualization
└── scripts/
    └── data_pipeline.py       # Automated data processing
```

## 🔥 Workshop Modules

### Module 1: Excel vs Pandas Comparison
- VLOOKUP vs `pd.merge()`
- Nested IFs vs vectorized operations
- Pivot Tables vs `groupby()`

### Module 2: Data Cleaning
- Handling missing values
- Data type conversions
- String manipulations

### Module 3: Data Visualization
- Line charts, bar charts, scatter plots
- Heatmaps and correlation matrices
- Interactive dashboards

## 💡 Why Python for Business?

1. **Reproducibility**: Run the same analysis with one click
2. **Scalability**: Handle datasets too large for Excel
3. **Automation**: Schedule reports to run automatically
4. **Collaboration**: Version control with Git
5. **Career Growth**: #1 most in-demand skill for data roles

## 📚 Resources

- [Pandas Documentation](https://pandas.pydata.org/docs/)
- [NumPy Documentation](https://numpy.org/doc/)
- [Matplotlib Gallery](https://matplotlib.org/stable/gallery/)
- [Seaborn Gallery](https://seaborn.pydata.org/examples/)

## 🤝 Contributing

Feel free to submit issues and pull requests!

## 📄 License

MIT License - feel free to use this for your own workshops!