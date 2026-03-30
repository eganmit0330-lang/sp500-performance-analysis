# S&P 500 Performance Analysis (2014–2017)

**Tools:** BigQuery (SQL) · Tableau Public  
**Dataset:** Maven Analytics · 20 S&P 500 stocks · Daily price data 2014–2017

---

## Project Overview
Analysis of daily price data for 20 S&P 500 stocks from 2014-2017 using BigQuery and Tableau. Examined annual returns, year-by-year performance rankings, and risk-adjusted returns to identify the strongest performers across a 4-year period.

---

## Dataset
- **Source:** Maven Analytics
- **Stocks analyzed:** AAPL, GOOGL, MSFT, AMZN, NFLX, BA, UNH, JPM, GS, BAC, ABT, C, CVX, GE, JNJ, MRK, PFE, WFC, XOM + 1 other
- **Date range:** January 2014 – December 2017
- **Tools:** BigQuery (SQL), Tableau Public

---

## Key Findings
1. NFLX delivered the highest raw annual return (avg +46.7%) but also the highest volatility — most volatile stock in 3 of 4 years studied.
2. AMZN delivered comparable returns (+42.5%) with significantly lower volatility — stronger risk-adjusted performance than NFLX despite lower headline numbers.
3. BA, MSFT, AAPL, GOOGL, and JPM all sat in the ideal quadrant: above-average returns with below-average volatility across the full period.
4. Year-by-year winners: AAPL (2014, +39.7%), NFLX (2015, +129.5%), UNH (2016, +37.4%), BA (2017, +87.9%).

---

## Recommendation
Investors seeking optimal risk-adjusted returns from this period should have overweighted BA, MSFT, AAPL, GOOGL, and JPM — stocks delivering above-average returns with below-average volatility. High-return plays like NFLX rewarded risk tolerance but carried nearly 2x the daily price swings of steadier compounders.

---

## SQL Skills Demonstrated
- Multi-CTE query architecture (4 chained CTEs)
- Self-joins to retrieve first and last trading day values
- Window functions (DENSE_RANK, PARTITION BY, rolling averages)
- Volatility metric definition and calculation
- Date functions (DATE_TRUNC, EXTRACT)
- NULLIF for division safety
- Conditional aggregation (CASE WHEN)

---

## Tableau Dashboard
[View on Tableau Public] https://public.tableau.com/views/SP500PerformanceDashboard/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link


