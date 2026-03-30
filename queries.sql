-- =============================================
-- S&P 500 Performance Analysis (2014-2017)
-- Author: Mitch Egan
-- Tools: BigQuery (Google Cloud)
-- Dataset: Maven Analytics via bigquery project
-- =============================================


-- =============================================
-- QUERY 1: Annual Return by Stock and Year
-- Returns: symbol, year, first close, last close,
--          and % return from first to last trading day
-- =============================================

WITH first_last_dates AS (
  -- Get the first and last trading date per stock per year
  SELECT
    symbol,
    DATE_TRUNC(date, YEAR)  AS year,
    MIN(date)               AS first_date,
    MAX(date)               AS last_date
  FROM `claude-data-489019.sp500.stock_prices`
  GROUP BY symbol, DATE_TRUNC(date, YEAR)
),
annual_prices AS (
  -- Self-join back to get closing prices on first and last dates
  SELECT
    f.symbol,
    f.year,
    ROUND(first_day.close, 2)  AS first_close,
    ROUND(last_day.close, 2)   AS last_close
  FROM first_last_dates f
  JOIN `claude-data-489019.sp500.stock_prices` first_day
    ON f.symbol = first_day.symbol
    AND f.first_date = first_day.date
  JOIN `claude-data-489019.sp500.stock_prices` last_day
    ON f.symbol = last_day.symbol
    AND f.last_date = last_day.date
)
SELECT
  symbol,
  year,
  first_close,
  last_close,
  ROUND(100.0 * (last_close - first_close)
        / NULLIF(first_close, 0), 2)  AS annual_return_pct
FROM annual_prices
ORDER BY symbol, year


-- =============================================
-- QUERY 2: Top 3 Stocks by Annual Return Per Year
-- Returns: year, symbol, return %, rank
-- Uses DENSE_RANK partitioned by year
-- =============================================

WITH first_last_dates AS (
  SELECT
    symbol,
    DATE_TRUNC(date, YEAR)  AS year,
    MIN(date)               AS first_date,
    MAX(date)               AS last_date
  FROM `claude-data-489019.sp500.stock_prices`
  GROUP BY symbol, DATE_TRUNC(date, YEAR)
),
annual_prices AS (
  SELECT
    f.symbol,
    f.year,
    ROUND(first_day.close, 2)  AS first_close,
    ROUND(last_day.close, 2)   AS last_close
  FROM first_last_dates f
  JOIN `claude-data-489019.sp500.stock_prices` first_day
    ON f.symbol = first_day.symbol
    AND f.first_date = first_day.date
  JOIN `claude-data-489019.sp500.stock_prices` last_day
    ON f.symbol = last_day.symbol
    AND f.last_date = last_day.date
),
annual_returns AS (
  SELECT
    symbol,
    year,
    ROUND(100.0 * (last_close - first_close)
          / NULLIF(first_close, 0), 2) AS annual_return_pct
  FROM annual_prices
),
ranked AS (
  -- Rank stocks within each year by return
  SELECT
    symbol,
    year,
    annual_return_pct,
    DENSE_RANK() OVER (
      PARTITION BY year
      ORDER BY annual_return_pct DESC
    ) AS rnk
  FROM annual_returns
)
SELECT *
FROM ranked
WHERE rnk <= 3
ORDER BY year, rnk


-- =============================================
-- QUERY 3: Volatility by Stock and Year
-- Volatility defined as avg daily price range
-- as a percentage of closing price
-- =============================================

SELECT
  symbol,
  DATE_TRUNC(date, YEAR)                          AS year,
  ROUND(AVG((high - low) / close) * 100, 2)       AS avg_daily_volatility_pct
FROM `claude-data-489019.sp500.stock_prices`
GROUP BY symbol, DATE_TRUNC(date, YEAR)
ORDER BY avg_daily_volatility_pct DESC


-- =============================================
-- QUERY 4: Risk vs Return by Stock (2014-2017)
-- Combines avg annual return with avg volatility
-- to identify best risk-adjusted performers
-- =============================================

WITH first_last_dates AS (
  SELECT
    symbol,
    DATE_TRUNC(date, YEAR)  AS year,
    MIN(date)               AS first_date,
    MAX(date)               AS last_date
  FROM `claude-data-489019.sp500.stock_prices`
  GROUP BY symbol, DATE_TRUNC(date, YEAR)
),
annual_prices AS (
  SELECT
    f.symbol,
    f.year,
    ROUND(first_day.close, 2)  AS first_close,
    ROUND(last_day.close, 2)   AS last_close
  FROM first_last_dates f
  JOIN `claude-data-489019.sp500.stock_prices` first_day
    ON f.symbol = first_day.symbol
    AND f.first_date = first_day.date
  JOIN `claude-data-489019.sp500.stock_prices` last_day
    ON f.symbol = last_day.symbol
    AND f.last_date = last_day.date
),
annual_returns AS (
  SELECT
    symbol,
    year,
    ROUND(100.0 * (last_close - first_close)
          / NULLIF(first_close, 0), 2) AS annual_return_pct
  FROM annual_prices
),
volatility AS (
  -- Avg volatility across all years per stock
  SELECT
    symbol,
    ROUND(AVG((high - low) / close) * 100, 2) AS avg_volatility_pct
  FROM `claude-data-489019.sp500.stock_prices`
  GROUP BY symbol
)
SELECT
  r.symbol,
  ROUND(AVG(r.annual_return_pct), 2)  AS avg_annual_return,
  v.avg_volatility_pct
FROM annual_returns r
JOIN volatility v
  ON r.symbol = v.symbol
GROUP BY r.symbol, v.avg_volatility_pct
ORDER BY avg_annual_return DESC
