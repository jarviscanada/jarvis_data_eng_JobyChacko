# Retail Data Wrangling and Analytics

## Introduction

London Gift Shop (LGS) is a UK-based online retailer specializing in giftware, with a significant portion of its customers being wholesalers. While the company has operated its online business for over a decade, revenue growth has recently stagnated. To address this, the LGS marketing team aims to better understand customer purchasing behavior and use data-driven insights to design more effective marketing strategies.

As part of a proof-of-concept engagement, Jarvis Consulting was tasked with analyzing historical transaction data to uncover actionable insights about customers, sales trends, and purchasing patterns. The results of this analysis enable the LGS marketing team to identify high-value customers, detect churn risks, and design targeted campaigns such as personalized promotions, retention offers, and re-engagement emails.

This project uses Python-based data analytics to answer key business questions and demonstrate how LGS can leverage its data assets to increase revenue and customer lifetime value.

---

## Implementation

### Project Architecture

This project follows a simplified analytics architecture suitable for a proof-of-concept:

1. **Data Source (OLTP)**
   Transactional retail data is stored in a PostgreSQL database, representing the operational data source provided by LGS.

2. **Data Access & Analytics Layer**
   - Data is extracted from PostgreSQL using SQLAlchemy.
   - Data wrangling, aggregation, and analysis are performed in a Jupyter Notebook using Python.

3. **Analytics Outputs**
   - Aggregated tables (e.g., sales trends, RFM metrics)
   - Visualizations (sales trends, customer segmentation, user growth)
   - Insights for marketing decision-making

4. **Consumption**
   The LGS marketing team can use these insights to inform campaign planning, customer segmentation, and promotional strategies.
   
   <img width="2030" height="828" alt="image" src="https://github.com/user-attachments/assets/2b8d0e63-550f-45bf-a7bf-a503db3b9a6a" />


---

### Data Analytics and Wrangling

- **Notebook:** Retail Data Analytics Wrangling Notebook : https://github.com/jarviscanada/jarvis_data_eng_JobyChacko/blob/89d9228cbffc07cd9dbc12030b3bac3b5c3fcd11/python_data_analytics/psql/python_data_wrangling/retail_data_analytics_wrangling_FINAL.ipynb

- **Key analytics performed:**
  - Sales trend analysis (monthly revenue and growth)
  - Customer behavior analysis (new vs existing users)
  - Invoice-level revenue analysis
  - RFM (Recency, Frequency, Monetary) customer segmentation

Using these analyses, LGS can:

- Identify **Champions** and **Loyal Customers** for premium or loyalty campaigns
- Re-engage **At Risk** and **About to Sleep** customers with targeted discounts
- Nurture **New Customers** and **Potential Loyalists** with onboarding and upsell strategies
- Reduce churn by proactively addressing declining engagement patterns

---

## Improvements

If more time were available, the following improvements would be implemented:

1. **Automated Data Pipeline**
   Build a scheduled ETL pipeline to refresh analytics automatically instead of relying on manual notebook execution.

2. **Advanced Customer Analytics**
   Apply clustering or predictive models (e.g., churn prediction, customer lifetime value forecasting) on top of RFM analysis.

3. **Dashboard & Visualization Layer**
   Develop an interactive dashboard (e.g., Tableau, Power BI, or Streamlit) to allow the marketing team to explore insights without running code.

