# PostgreSQL Practice Sheet — pgExercises

**Author:** Joby Chacko  
**Environment:** Rocky Linux (JRVS Remote Desktop)  

---

## Overview

This repository contains a **structured PostgreSQL practice environment** based on exercises from [pgExercises.com].  
It is designed to build **interview-ready SQL skills** across:

- CRUD operations (INSERT, UPDATE, DELETE)
- Filtering and conditions (WHERE, LIKE, IN, UNION)
- Joins (INNER JOIN, LEFT JOIN, self-joins, subqueries)
- Aggregation (GROUP BY, COUNT, SUM, DISTINCT)
- Window functions (ROW_NUMBER, RANK, PARTITION BY)
- String manipulation (concatenation, pattern matching, substrings)

The project is organized to separate **database setup** from **query practice**, following real-world workflow patterns.

---

## Project Structure

```text
.
├── clubdata.sql   # Database schema and sample data (pgExercises dataset)
├── queries.sql    # Main SQL practice sheet 
└── README.md     # Project documentation
