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

   <img width="960" height="303" alt="image" src="https://github.com/user-attachments/assets/4414f9e1-0e80-4144-8170-4d57f83af91f" />

---

### Data Analytics and Wrangling

- **Notebook:** [Retail Data Analytics Wrangling Notebook](https://github.com/jarviscanada/jarvis_data_eng_JobyChacko/blob/89d9228cbffc07cd9dbc12030b3bac3b5c3fcd11/python_data_analytics/psql/python_data_wrangling/retail_data_analytics_wrangling_FINAL.ipynb)

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

## Key Visualizations and Insights

### Customer Segmentation (RFM)

<img width="502" height="322" alt="image" src="https://github.com/user-attachments/assets/b829a86c-0da9-427f-9280-2cb0cd44d352" />


> **Insight:** RFM segmentation shows that a significant portion of the customer base falls into dormant segments, while a smaller group of high-value customers generates the majority of revenue.

> **Relevance:** Customer segmentation allows the business to prioritize retention of valuable customers and develop targeted re-engagement strategies for inactive users.

---

### Revenue Contribution by Customer Segment

<img width="462" height="440" alt="image" src="https://github.com/user-attachments/assets/1b7dfa47-091c-4899-a31a-7a600d827549" />


> **Insight:** Revenue analysis shows strong concentration among high-value customers, with Champions and Loyal Customers contributing the majority of total revenue.

> **Relevance:** Understanding revenue concentration helps the business protect its most valuable customers and prioritize marketing efforts where they will have the greatest impact.

---

### Dormant Customer Revenue Recovery

<img width="462" height="340" alt="image" src="https://github.com/user-attachments/assets/9312ebd8-9ba9-4e94-9915-3e41269b7087" />


> **Insight:** Dormant customers represent a meaningful portion of historical revenue. Even a modest reactivation rate can generate measurable incremental revenue.

> **Relevance:** Targeted win-back campaigns provide an opportunity to increase revenue using the existing customer base rather than relying solely on new customer acquisition.

---

## Improvements

If more time were available, the following improvements would be implemented:

1. **Automated Data Pipeline**
   Build a scheduled ETL pipeline to refresh analytics automatically instead of relying on manual notebook execution.

2. **Advanced Customer Analytics**
   Apply clustering or predictive models (e.g., churn prediction, customer lifetime value forecasting) on top of RFM analysis.

3. **Dashboard & Visualization Layer**
   Develop an interactive dashboard (e.g., Tableau, Power BI, or Streamlit) to allow the marketing team to explore insights without running code.
