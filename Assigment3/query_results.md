# Superstore Sales Analysis - SQL Query Results and Insights

This document compiles the SQL query executions, formatted outputs, and detailed business insights run against `superstore.db` built from `Sample - Superstore.csv`.

## 02_subqueries.sql

### Subqueries Analysis

```sql
-- =====================================================================
-- Subqueries Analysis
-- =====================================================================

-- Query 1: Find all order items where the sales amount is above the overall average sales.
-- This uses a subquery to compute the overall average sales.
SELECT 
    order_id, 
    customer_id, 
    product_id, 
    sales
FROM 
    orders
WHERE 
    sales > (SELECT AVG(sales) FROM orders)
ORDER BY 
    sales DESC
LIMIT 10
```

#### Results:

| order_id | customer_id | product_id | sales |
| --- | --- | --- | --- |
| CA-2014-145317 | SM-20320 | TEC-MA-10002412 | 22638.48 |
| CA-2016-118689 | TC-20980 | TEC-CO-10004722 | 17499.95 |
| CA-2017-140151 | RB-19360 | TEC-CO-10004722 | 13999.96 |
| CA-2017-127180 | TA-21385 | TEC-CO-10004722 | 11199.968 |
| CA-2017-166709 | HL-15040 | TEC-CO-10004722 | 10499.97 |
| CA-2016-117121 | AB-10105 | OFF-BI-10000545 | 9892.74 |
| CA-2014-116904 | SC-20095 | OFF-BI-10001120 | 9449.95 |
| US-2016-107440 | BS-11365 | TEC-MA-10001047 | 9099.93 |
| CA-2016-158841 | SE-20110 | TEC-MA-10001127 | 8749.95 |
| CA-2016-143714 | CC-12370 | TEC-CO-10004722 | 8399.976 |

**Detailed Business Insight:**

- **Benchmark Comparison:** The average line-item sale in the dataset is **$229.86**. The results filter out the highest-value transactions, showing that items exceeding this average are dominated by Technology products (e.g., Copiers, Machines).
- **Revenue Drivers:** The single highest sale in the entire dataset is a machine purchased by customer Sean Miller (`SM-20320`) for **$22,638.48**. This highlights that while low-cost office supplies make up the bulk of purchase transactions, a tiny minority of large-ticket technology sales drive outsized revenue.

### Limited to top 10 for display purposes in queries, but runner will retrieve full counts.

```sql
-- Limited to top 10 for display purposes in queries, but runner will retrieve full counts.


-- Query 2: Find the highest single-item sale record (highest line-item sales) for each customer.
-- This uses a correlated subquery to identify the maximum sale for each customer.
SELECT 
    o1.customer_id, 
    o1.order_id, 
    o1.product_id, 
    o1.sales
FROM 
    orders o1
WHERE 
    o1.sales = (
        SELECT MAX(o2.sales)
        FROM orders o2
        WHERE o2.customer_id = o1.customer_id
    )
ORDER BY 
    o1.sales DESC
LIMIT 10
```

#### Results:

| customer_id | order_id | product_id | sales |
| --- | --- | --- | --- |
| SM-20320 | CA-2014-145317 | TEC-MA-10002412 | 22638.48 |
| TC-20980 | CA-2016-118689 | TEC-CO-10004722 | 17499.95 |
| RB-19360 | CA-2017-140151 | TEC-CO-10004722 | 13999.96 |
| TA-21385 | CA-2017-127180 | TEC-CO-10004722 | 11199.968 |
| HL-15040 | CA-2017-166709 | TEC-CO-10004722 | 10499.97 |
| AB-10105 | CA-2016-117121 | OFF-BI-10000545 | 9892.74 |
| SC-20095 | CA-2014-116904 | OFF-BI-10001120 | 9449.95 |
| BS-11365 | US-2016-107440 | TEC-MA-10001047 | 9099.93 |
| SE-20110 | CA-2016-158841 | TEC-MA-10001127 | 8749.95 |
| CC-12370 | CA-2016-143714 | TEC-CO-10004722 | 8399.976 |

**Detailed Business Insight:**

- **Customer Profiling:** This correlated subquery maps each customer to their single largest transaction. By reviewing the top values, we identify customers with high enterprise-scale spending capability (such as Sean Miller, Tamara Chand, and Raymond Buch, with peak purchases of $22,638.48, $17,499.95, and $13,999.96 respectively).
- **Segment Dispersity:** It exposes the massive tier gaps among buyers. Some accounts' largest single-item purchase is in the tens of thousands, while others' peak spend is below $10, highlighting the necessity of segment-specific catalog offerings and marketing strategies.

### Limited to top 10 for quick preview, runner will show count and sample.

```sql
-- Limited to top 10 for quick preview, runner will show count and sample.
```

Executed successfully (no rows returned).

## 03_ctes.sql

### Common Table Expressions (CTEs) Analysis

```sql
-- =====================================================================
-- Common Table Expressions (CTEs) Analysis
-- =====================================================================

-- Query: Use a CTE to compute aggregations (total sales, total orders, total quantity) per customer.
-- This groups orders by customer_id in a CTE, then joins with the customers table for names and segments.
WITH customer_aggregates AS (
    SELECT 
        customer_id, 
        SUM(sales) AS total_sales,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(quantity) AS total_items
    FROM 
        orders
    GROUP BY 
        customer_id
)
SELECT 
    ca.customer_id,
    c.customer_name,
    c.segment,
    ROUND(ca.total_sales, 2) AS total_sales,
    ca.total_orders,
    ca.total_items
FROM 
    customer_aggregates ca
JOIN 
    customers c ON ca.customer_id = c.customer_id
ORDER BY 
    total_sales DESC
LIMIT 10
```

#### Results:

| customer_id | customer_name | segment | total_sales | total_orders | total_items |
| --- | --- | --- | --- | --- | --- |
| SM-20320 | Sean Miller | Home Office | 25043.05 | 5 | 50 |
| TC-20980 | Tamara Chand | Corporate | 19052.22 | 5 | 42 |
| RB-19360 | Raymond Buch | Consumer | 15117.34 | 6 | 71 |
| TA-21385 | Tom Ashbrook | Home Office | 14595.62 | 4 | 36 |
| AB-10105 | Adrian Barton | Consumer | 14473.57 | 10 | 73 |
| KL-16645 | Ken Lonsdale | Consumer | 14175.23 | 12 | 113 |
| SC-20095 | Sanjit Chand | Consumer | 14142.33 | 9 | 87 |
| HL-15040 | Hunter Lopez | Consumer | 12873.3 | 6 | 50 |
| SE-20110 | Sanjit Engle | Consumer | 12209.44 | 11 | 78 |
| CC-12370 | Christopher Conant | Consumer | 12129.07 | 5 | 34 |

**Detailed Business Insight:**

- **High-Value Account (HVA) Identification:** The CTE groups order transactions to yield a single aggregated customer lifetime value (LTV). Sean Miller leads with a total spend of **$25,043.05**.
- **Volume vs. Value Analysis:** We can compare total spend with total orders and items. For instance, Adrian Barton (`AB-10105`) spent **$14,473.57** across 10 orders (73 items), whereas Ken Lonsdale (`KL-16645`) bought 113 items across 12 orders for a total of **$14,175.23**. This reveals that Ken Lonsdale is a high-frequency purchaser of lower-priced items, whereas Adrian Barton places larger, high-value orders.

## 04_window_functions.sql

### Window Functions Analysis

```sql
-- =====================================================================
-- Window Functions Analysis
-- =====================================================================

-- Query 1: Rank all customers by their total sales using ROW_NUMBER() and RANK() to show the difference.
WITH customer_sales AS (
    SELECT 
        customer_id, 
        SUM(sales) AS total_sales
    FROM 
        orders
    GROUP BY 
        customer_id
)
SELECT 
    cs.customer_id,
    c.customer_name,
    ROUND(cs.total_sales, 2) AS total_sales,
    ROW_NUMBER() OVER (ORDER BY cs.total_sales DESC) AS sales_row_num,
    RANK() OVER (ORDER BY cs.total_sales DESC) AS sales_rank
FROM 
    customer_sales cs
JOIN 
    customers c ON cs.customer_id = c.customer_id
ORDER BY 
    total_sales DESC
LIMIT 10
```

#### Results:

| customer_id | customer_name | total_sales | sales_row_num | sales_rank |
| --- | --- | --- | --- | --- |
| SM-20320 | Sean Miller | 25043.05 | 1 | 1 |
| TC-20980 | Tamara Chand | 19052.22 | 2 | 2 |
| RB-19360 | Raymond Buch | 15117.34 | 3 | 3 |
| TA-21385 | Tom Ashbrook | 14595.62 | 4 | 4 |
| AB-10105 | Adrian Barton | 14473.57 | 5 | 5 |
| KL-16645 | Ken Lonsdale | 14175.23 | 6 | 6 |
| SC-20095 | Sanjit Chand | 14142.33 | 7 | 7 |
| HL-15040 | Hunter Lopez | 12873.3 | 8 | 8 |
| SE-20110 | Sanjit Engle | 12209.44 | 9 | 9 |
| CC-12370 | Christopher Conant | 12129.07 | 10 | 10 |

**Detailed Business Insight:**

- **Ranking System Mechanics:** This query contrasts two analytical window functions. `ROW_NUMBER()` enforces a strict, unique sequential number from 1 to 793 regardless of duplicate values. `RANK()` assigns the same rank value to identical values (ties) and skips the subsequent ranking numbers.
- **Data Distribution:** Because customer total sales in this dataset are precise floating-point figures, there are no identical ties in the top ranks. Thus, both functions produce identical rank values for the top tier. However, this query serves as a template for business reports where pricing or quantity ties are common.

### Query 2: Partition and rank customers within their respective customer segment by total sales.

```sql
-- Query 2: Partition and rank customers within their respective customer segment by total sales.
-- This uses DENSE_RANK() partitioned by customer segment.
WITH customer_sales AS (
    SELECT 
        customer_id, 
        SUM(sales) AS total_sales
    FROM 
        orders
    GROUP BY 
        customer_id
)
SELECT 
    cs.customer_id,
    c.customer_name,
    c.segment,
    ROUND(cs.total_sales, 2) AS total_sales,
    DENSE_RANK() OVER (PARTITION BY c.segment ORDER BY cs.total_sales DESC) AS segment_sales_rank
FROM 
    customer_sales cs
JOIN 
    customers c ON cs.customer_id = c.customer_id
ORDER BY 
    c.segment, 
    segment_sales_rank
LIMIT 15
```

#### Results:

| customer_id | customer_name | segment | total_sales | segment_sales_rank |
| --- | --- | --- | --- | --- |
| RB-19360 | Raymond Buch | Consumer | 15117.34 | 1 |
| AB-10105 | Adrian Barton | Consumer | 14473.57 | 2 |
| KL-16645 | Ken Lonsdale | Consumer | 14175.23 | 3 |
| SC-20095 | Sanjit Chand | Consumer | 14142.33 | 4 |
| HL-15040 | Hunter Lopez | Consumer | 12873.3 | 5 |
| SE-20110 | Sanjit Engle | Consumer | 12209.44 | 6 |
| CC-12370 | Christopher Conant | Consumer | 12129.07 | 7 |
| GT-14710 | Greg Tran | Consumer | 11820.12 | 8 |
| BM-11140 | Becky Martin | Consumer | 11789.63 | 9 |
| SV-20365 | Seth Vernon | Consumer | 11470.95 | 10 |
| CJ-12010 | Caroline Jumper | Consumer | 11164.97 | 11 |
| CL-12565 | Clay Ludtke | Consumer | 10880.55 | 12 |
| JL-15835 | John Lee | Consumer | 9799.92 | 13 |
| TB-21400 | Tom Boeckenhauer | Consumer | 9133.99 | 14 |
| PF-19120 | Peter Fuller | Consumer | 9062.86 | 15 |

**Detailed Business Insight:**

- **Segment Dominance:** By partitioning by customer segment (`Consumer`, `Corporate`, `Home Office`), we isolate the market leaders within each demographic.
- **Leaders by Segment:**
  - **Consumer Segment Top:** Raymond Buch ($15,117.34, Segment Rank 1), Adrian Barton ($14,473.57, Segment Rank 2).
  - **Corporate Segment Top:** Tamara Chand ($19,052.22, Segment Rank 1), Todd Sumrall ($11,891.75, Segment Rank 2).
  - **Home Office Segment Top:** Sean Miller ($25,043.05, Segment Rank 1), Tom Ashbrook ($14,595.62, Segment Rank 2).
- **Strategic Targeting:** Segment ranks allow the sales team to set quota expectations and run tailored promotions for high-performing business accounts separately from private consumer accounts.

## 05_business_queries.sql

### Business Queries using JOINs, CTEs, and Window Functions

```sql
-- =====================================================================
-- Business Queries using JOINs, CTEs, and Window Functions
-- =====================================================================

-- Query 1: Combined Query (JOIN + CTE + Window Functions)
-- Groups customer sales and ranks them using a window function, joining customer metadata.
WITH customer_sales_rank AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        c.segment,
        SUM(o.sales) AS total_sales,
        RANK() OVER (ORDER BY SUM(o.sales) DESC) AS customer_rank
    FROM 
        customers c
    JOIN 
        orders o ON c.customer_id = o.customer_id
    GROUP BY 
        c.customer_id, c.customer_name, c.segment
)
SELECT 
    customer_name,
    segment,
    ROUND(total_sales, 2) AS total_sales,
    customer_rank
FROM 
    customer_sales_rank
ORDER BY 
    customer_rank
```

#### Results:

| customer_name | segment | total_sales | customer_rank |
| --- | --- | --- | --- |
| Sean Miller | Home Office | 25043.05 | 1 |
| Tamara Chand | Corporate | 19052.22 | 2 |
| Raymond Buch | Consumer | 15117.34 | 3 |
| Tom Ashbrook | Home Office | 14595.62 | 4 |
| Adrian Barton | Consumer | 14473.57 | 5 |
| Ken Lonsdale | Consumer | 14175.23 | 6 |
| Sanjit Chand | Consumer | 14142.33 | 7 |
| Hunter Lopez | Consumer | 12873.3 | 8 |
| Sanjit Engle | Consumer | 12209.44 | 9 |
| Christopher Conant | Consumer | 12129.07 | 10 |
| Todd Sumrall | Corporate | 11891.75 | 11 |
| Greg Tran | Consumer | 11820.12 | 12 |
| Becky Martin | Consumer | 11789.63 | 13 |
| Seth Vernon | Consumer | 11470.95 | 14 |
| Caroline Jumper | Consumer | 11164.97 | 15 |
| Clay Ludtke | Consumer | 10880.55 | 16 |
| Maria Etezadi | Home Office | 10663.73 | 17 |
| Karen Ferguson | Home Office | 10604.27 | 18 |
| Bill Shonely | Corporate | 10501.65 | 19 |
| Edward Hooks | Corporate | 10310.88 | 20 |
| John Lee | Consumer | 9799.92 | 21 |
| Grant Thornton | Corporate | 9351.21 | 22 |
| Helen Wasserman | Corporate | 9300.25 | 23 |
| Tom Boeckenhauer | Consumer | 9133.99 | 24 |
| Peter Fuller | Consumer | 9062.86 | 25 |
| Christopher Martinez | Consumer | 8954.02 | 26 |
| Justin Deggeller | Corporate | 8828.03 | 27 |
| Joe Elijah | Consumer | 8697.84 | 28 |
| Laura Armstrong | Corporate | 8673.22 | 29 |
| Pete Kriz | Consumer | 8646.93 | 30 |
| Daniel Raglin | Home Office | 8350.87 | 31 |
| Natalie Fritzler | Consumer | 8322.83 | 32 |
| Karen Daniels | Consumer | 8282.36 | 33 |
| Nick Crebassa | Corporate | 8241.74 | 34 |
| Harry Marie | Corporate | 8236.76 | 35 |
| Keith Dawkins | Corporate | 8181.26 | 36 |
| Sean Braxton | Corporate | 8057.89 | 37 |
| Zuschuss Carroll | Consumer | 8025.71 | 38 |
| Joseph Holt | Consumer | 7955.0 | 39 |
| Nora Preis | Consumer | 7903.18 | 40 |
| Anna Häberlin | Corporate | 7888.29 | 41 |
| Adam Bellavance | Home Office | 7755.62 | 42 |
| Jim Epp | Corporate | 7754.98 | 43 |
| Jane Waco | Corporate | 7721.71 | 44 |
| Lena Creighton | Consumer | 7663.13 | 45 |
| John Murray | Consumer | 7625.08 | 46 |
| Jonathan Doherty | Corporate | 7610.86 | 47 |
| Patrick O'Brill | Consumer | 7473.83 | 48 |
| Maribeth Schnelling | Consumer | 7443.69 | 49 |
| Rick Wilson | Corporate | 7397.4 | 50 |
| Brian Moss | Corporate | 7294.19 | 51 |
| Paul Prost | Home Office | 7252.61 | 52 |
| Natalie Webber | Consumer | 7234.01 | 53 |
| Dean percer | Home Office | 7198.76 | 54 |
| Fred Hopkins | Corporate | 6987.2 | 55 |
| Rick Huthwaite | Home Office | 6979.18 | 56 |
| Penelope Sewall | Home Office | 6843.63 | 57 |
| Brenda Bowman | Corporate | 6765.73 | 58 |
| Joel Eaton | Consumer | 6760.81 | 59 |
| Yana Sorensen | Corporate | 6720.44 | 60 |
| Andy Reiter | Consumer | 6608.45 | 61 |
| Dan Reichenbach | Corporate | 6528.03 | 62 |
| Grace Kelly | Corporate | 6497.27 | 63 |
| Joseph Airdo | Consumer | 6491.03 | 64 |
| Nathan Mautz | Home Office | 6459.34 | 65 |
| Valerie Dominguez | Consumer | 6442.25 | 66 |
| Sarah Brown | Consumer | 6411.0 | 67 |
| James Galang | Consumer | 6366.39 | 68 |
| Darrin Martin | Consumer | 6345.1 | 69 |
| Corinna Mitchell | Home Office | 6339.56 | 70 |
| Max Jones | Consumer | 6320.75 | 71 |
| Brosina Hoffman | Consumer | 6255.35 | 72 |
| Rob Lucas | Consumer | 6234.91 | 73 |
| William Brown | Consumer | 6160.1 | 74 |
| Victoria Wilson | Corporate | 6134.04 | 75 |
| Shirley Daniels | Home Office | 6121.11 | 76 |
| Quincy Jones | Corporate | 6108.34 | 77 |
| Alan Dominguez | Home Office | 6106.88 | 78 |
| Cassandra Brandow | Consumer | 6076.14 | 79 |
| Greg Maxwell | Corporate | 6049.97 | 80 |
| Shahid Collister | Consumer | 5992.54 | 81 |
| Kristen Hastings | Corporate | 5990.8 | 82 |
| Robert Marley | Home Office | 5979.1 | 83 |
| Keith Herrera | Consumer | 5952.86 | 84 |
| Ben Ferrer | Home Office | 5907.97 | 85 |
| Christine Phan | Corporate | 5888.27 | 86 |
| Bill Donatelli | Consumer | 5718.52 | 87 |
| Cindy Stewart | Consumer | 5690.05 | 88 |
| Anne McFarland | Consumer | 5664.02 | 89 |
| Ross Baird | Home Office | 5633.32 | 90 |
| Katherine Murray | Home Office | 5620.19 | 91 |
| Alex Avila | Consumer | 5563.56 | 92 |
| Suzanne McNair | Corporate | 5563.39 | 93 |
| Naresj Patel | Consumer | 5529.62 | 94 |
| Amy Cox | Consumer | 5527.85 | 95 |
| Mick Hernandez | Home Office | 5503.09 | 96 |
| Dennis Pardue | Home Office | 5480.72 | 97 |
| Emily Phan | Consumer | 5478.06 | 98 |
| Yoseph Carroll | Corporate | 5454.35 | 99 |
| Stefania Perrino | Corporate | 5440.32 | 100 |
| Luke Weiss | Consumer | 5420.51 | 101 |
| Cathy Prescott | Corporate | 5402.25 | 102 |
| Thomas Seio | Corporate | 5371.09 | 103 |
| Tonja Turnell | Home Office | 5364.81 | 104 |
| Mitch Webber | Consumer | 5341.9 | 105 |
| Tom Prescott | Consumer | 5329.0 | 106 |
| Tamara Willingham | Home Office | 5278.83 | 107 |
| Dianna Wilson | Home Office | 5271.63 | 108 |
| Mitch Willingham | Corporate | 5253.88 | 109 |
| Harold Ryan | Corporate | 5248.79 | 110 |
| Steven Cartwright | Consumer | 5226.21 | 111 |
| Resi Pölking | Consumer | 5153.08 | 112 |
| Lena Radford | Consumer | 5142.89 | 113 |
| Mike Pelletier | Home Office | 5087.92 | 114 |
| Anna Andreadi | Consumer | 5086.94 | 115 |
| Ivan Liston | Consumer | 5040.74 | 116 |
| Kelly Lampkin | Corporate | 5016.49 | 117 |
| Laurel Beltran | Home Office | 4985.68 | 118 |
| Dave Hallsten | Corporate | 4932.87 | 119 |
| Irene Maddox | Consumer | 4930.47 | 120 |
| Ted Trevino | Consumer | 4915.6 | 121 |
| Kunst Miller | Consumer | 4909.47 | 122 |
| Philisse Overcash | Home Office | 4893.04 | 123 |
| Heather Kirkland | Corporate | 4877.78 | 124 |
| Anthony Jacobs | Corporate | 4867.34 | 125 |
| Joe Kamberova | Consumer | 4867.2 | 126 |
| Alan Hwang | Consumer | 4805.34 | 127 |
| Dean Katz | Corporate | 4802.39 | 128 |
| Russell Applegate | Consumer | 4793.54 | 129 |
| Sue Ann Reed | Consumer | 4767.34 | 130 |
| Jim Kriz | Home Office | 4760.43 | 131 |
| Bart Watters | Corporate | 4750.36 | 132 |
| Tracy Blumstein | Consumer | 4737.49 | 133 |
| Giulietta Baptist | Consumer | 4716.29 | 134 |
| Rick Bensley | Home Office | 4715.47 | 135 |
| Erin Smith | Corporate | 4657.92 | 136 |
| Deborah Brumfield | Home Office | 4655.9 | 137 |
| Kean Thornton | Consumer | 4642.09 | 138 |
| Sample Company A | Home Office | 4624.57 | 139 |
| Eugene Moren | Home Office | 4588.44 | 140 |
| Dave Brooks | Consumer | 4531.65 | 141 |
| Anthony Rawles | Corporate | 4523.34 | 142 |
| Arthur Gainer | Consumer | 4510.8 | 143 |
| Anthony Johnson | Corporate | 4501.39 | 144 |
| Linda Cazamias | Corporate | 4492.95 | 145 |
| Stewart Carmichael | Corporate | 4492.66 | 146 |
| Theone Pippenger | Consumer | 4454.06 | 147 |
| Mark Cousins | Corporate | 4432.14 | 148 |
| Jamie Kunitz | Consumer | 4427.14 | 149 |
| Katrina Willman | Consumer | 4416.52 | 150 |
| Bradley Drucker | Consumer | 4411.24 | 151 |
| Arianne Irving | Consumer | 4375.79 | 152 |
| Scot Coram | Corporate | 4371.96 | 153 |
| Ellis Ballard | Corporate | 4358.13 | 154 |
| Gary Zandusky | Consumer | 4355.15 | 155 |
| Steven Roelle | Home Office | 4345.89 | 156 |
| Natalie DeCherney | Consumer | 4326.14 | 157 |
| Matt Abelman | Home Office | 4299.16 | 158 |
| Sung Pak | Corporate | 4282.94 | 159 |
| Dana Kaydos | Consumer | 4282.18 | 160 |
| Rick Duston | Consumer | 4272.93 | 161 |
| Toby Carlisle | Consumer | 4266.81 | 162 |
| Alan Schoenberger | Corporate | 4260.78 | 163 |
| Frank Hawley | Corporate | 4256.27 | 164 |
| Claudia Bergmann | Corporate | 4246.46 | 165 |
| Tracy Hopkins | Home Office | 4234.1 | 166 |
| Bill Eplett | Home Office | 4204.68 | 167 |
| Jill Fjeld | Consumer | 4198.33 | 168 |
| Gary Hwang | Consumer | 4172.85 | 169 |
| Roland Schwarz | Corporate | 4159.77 | 170 |
| Muhammed Yedwab | Corporate | 4152.7 | 171 |
| Peter McVee | Home Office | 4115.66 | 172 |
| Stewart Visinsky | Consumer | 4105.31 | 173 |
| Denise Monton | Corporate | 4074.47 | 174 |
| Frank Preis | Consumer | 4046.75 | 175 |
| Susan Pistek | Consumer | 3990.69 | 176 |
| Craig Molinari | Corporate | 3984.45 | 177 |
| Michael Paige | Corporate | 3983.64 | 178 |
| Sean Christensen | Consumer | 3979.07 | 179 |
| Sanjit Jacobs | Home Office | 3949.66 | 180 |
| Luke Foster | Consumer | 3930.51 | 181 |
| Pierre Wener | Consumer | 3922.41 | 182 |
| George Ashbrook | Consumer | 3919.78 | 183 |
| Ken Heidel | Corporate | 3918.97 | 184 |
| Chris Cortes | Consumer | 3913.42 | 185 |
| Dorothy Badders | Corporate | 3908.8 | 186 |
| Nora Paige | Consumer | 3908.4 | 187 |
| Kelly Collister | Consumer | 3908.26 | 188 |
| Fred Chung | Corporate | 3889.37 | 189 |
| Bill Stewart | Corporate | 3887.83 | 190 |
| John Stevenson | Consumer | 3868.02 | 191 |
| Ruben Ausman | Corporate | 3832.31 | 192 |
| Annie Thurman | Consumer | 3831.86 | 193 |
| Olvera Toch | Consumer | 3818.62 | 194 |
| Rose O'Brian | Consumer | 3815.48 | 195 |
| Michael Chen | Consumer | 3805.71 | 196 |
| Michael Moore | Consumer | 3794.08 | 197 |
| Carol Adams | Corporate | 3789.72 | 198 |
| Matthew Grinstein | Home Office | 3785.28 | 199 |
| Maribeth Dona | Consumer | 3766.38 | 200 |
| Jim Karlsson | Consumer | 3760.03 | 201 |
| Juliana Krohn | Consumer | 3747.67 | 202 |
| Frank Merwin | Home Office | 3736.2 | 203 |
| Scott Cohen | Corporate | 3729.79 | 204 |
| Hunter Glantz | Consumer | 3690.28 | 205 |
| Ben Peterman | Corporate | 3675.86 | 206 |
| Liz Preis | Consumer | 3653.4 | 207 |
| Christopher Schild | Home Office | 3651.86 | 208 |
| Ed Braxton | Corporate | 3644.98 | 209 |
| Jeremy Pistek | Consumer | 3635.59 | 210 |
| Sam Zeldin | Home Office | 3625.33 | 211 |
| Rick Hansen | Consumer | 3621.38 | 212 |
| Thomas Boland | Corporate | 3589.3 | 213 |
| Gary McGarr | Consumer | 3582.82 | 214 |
| Dionis Lloyd | Corporate | 3539.32 | 215 |
| Erica Smith | Consumer | 3510.46 | 216 |
| Robert Waldorf | Consumer | 3495.65 | 217 |
| Anna Gayman | Consumer | 3489.04 | 218 |
| Emily Ducich | Home Office | 3484.92 | 219 |
| Pauline Webber | Corporate | 3454.92 | 220 |
| Sarah Foster | Consumer | 3422.79 | 221 |
| Frank Carlisle | Home Office | 3418.74 | 222 |
| Sally Hughsby | Corporate | 3406.84 | 223 |
| Sandra Glassco | Consumer | 3406.58 | 224 |
| Trudy Schmidt | Consumer | 3368.09 | 225 |
| Sam Craven | Consumer | 3362.96 | 226 |
| Victoria Pisteka | Corporate | 3360.53 | 227 |
| Doug Jacobs | Consumer | 3356.4 | 228 |
| Dianna Vittorini | Consumer | 3341.59 | 229 |
| Sylvia Foulston | Corporate | 3336.54 | 230 |
| Dan Campbell | Consumer | 3336.17 | 231 |
| Arthur Prichep | Consumer | 3323.56 | 232 |
| Dennis Kane | Consumer | 3318.49 | 233 |
| Katharine Harms | Corporate | 3312.86 | 234 |
| Randy Ferguson | Corporate | 3309.15 | 235 |
| Rick Reed | Corporate | 3302.26 | 236 |
| Brian Dahlen | Consumer | 3288.47 | 237 |
| Brian Stugart | Consumer | 3288.11 | 238 |
| Rob Williams | Corporate | 3279.75 | 239 |
| Daniel Lacy | Consumer | 3272.2 | 240 |
| Damala Kotsonis | Corporate | 3256.48 | 241 |
| Adam Shillingsburg | Consumer | 3255.31 | 242 |
| Jack O'Briant | Corporate | 3254.95 | 243 |
| Adam Hart | Corporate | 3250.34 | 244 |
| Henry Goldwyn | Corporate | 3247.64 | 245 |
| Lindsay Castell | Home Office | 3246.63 | 246 |
| Carol Triggs | Consumer | 3241.9 | 247 |
| Edward Becker | Corporate | 3236.31 | 248 |
| Sharelle Roach | Home Office | 3233.48 | 249 |
| Lindsay Williams | Corporate | 3230.31 | 250 |
| Ricardo Sperren | Corporate | 3221.29 | 251 |
| Alejandro Savely | Corporate | 3214.24 | 252 |
| Mark Packer | Home Office | 3206.13 | 253 |
| Christine Sundaresam | Consumer | 3202.16 | 254 |
| Brian Thompson | Consumer | 3196.75 | 255 |
| Deirdre Greer | Corporate | 3195.82 | 256 |
| Jeremy Lonsdale | Consumer | 3173.87 | 257 |
| Greg Matthias | Consumer | 3163.63 | 258 |
| Janet Martin | Consumer | 3159.12 | 259 |
| Chloris Kastensmidt | Consumer | 3154.86 | 260 |
| Karen Bern | Corporate | 3152.61 | 261 |
| Maxwell Schwartz | Consumer | 3144.68 | 262 |
| Ruben Dartt | Consumer | 3133.92 | 263 |
| Tanja Norvell | Home Office | 3130.22 | 264 |
| Steve Nguyen | Home Office | 3127.96 | 265 |
| Speros Goranitis | Consumer | 3124.83 | 266 |
| Katherine Hughes | Consumer | 3100.61 | 267 |
| Patrick Gardner | Consumer | 3086.91 | 268 |
| Eugene Hildebrand | Home Office | 3082.65 | 269 |
| Gary Mitchum | Home Office | 3078.62 | 270 |
| Eugene Barchas | Consumer | 3071.13 | 271 |
| Mike Gockenbach | Consumer | 3061.54 | 272 |
| Toby Gnade | Consumer | 3058.37 | 273 |
| Kean Takahito | Consumer | 3057.1 | 274 |
| Shahid Shariari | Consumer | 3056.81 | 275 |
| Sara Luxemburg | Home Office | 3053.01 | 276 |
| Aaron Smayling | Corporate | 3050.69 | 277 |
| Cynthia Arntzen | Consumer | 3041.57 | 278 |
| Carlos Soltero | Consumer | 3036.55 | 279 |
| Lindsay Shagiari | Home Office | 2988.67 | 280 |
| Michelle Huthwaite | Consumer | 2984.95 | 281 |
| Frank Atkinson | Corporate | 2984.05 | 282 |
| David Bremer | Corporate | 2973.09 | 283 |
| Noel Staavos | Corporate | 2964.82 | 284 |
| Tamara Manning | Consumer | 2955.23 | 285 |
| Christine Kargatis | Home Office | 2945.32 | 286 |
| Thea Hudgings | Corporate | 2942.77 | 287 |
| Liz Thompson | Consumer | 2936.25 | 288 |
| Becky Castell | Home Office | 2933.68 | 289 |
| Julie Kriz | Home Office | 2932.48 | 290 |
| Shaun Weien | Consumer | 2921.54 | 291 |
| Maris LaWare | Consumer | 2921.5 | 292 |
| Rob Dowd | Consumer | 2912.89 | 293 |
| Craig Yedwab | Corporate | 2900.03 | 294 |
| Neil Ducich | Corporate | 2893.45 | 295 |
| Meg Tillman | Consumer | 2890.14 | 296 |
| Barry Französisch | Corporate | 2888.51 | 297 |
| David Smith | Corporate | 2881.81 | 298 |
| Paul Van Hugh | Home Office | 2876.05 | 299 |
| Ionia McGrath | Consumer | 2872.63 | 300 |
| Chuck Clark | Home Office | 2870.05 | 301 |
| Craig Carroll | Consumer | 2854.12 | 302 |
| Arthur Wiediger | Home Office | 2852.97 | 303 |
| Erin Ashbrook | Corporate | 2846.7 | 304 |
| Linda Southworth | Corporate | 2845.27 | 305 |
| Darren Budd | Corporate | 2839.23 | 306 |
| Justin MacKendrick | Consumer | 2833.93 | 307 |
| Christina VanderZanden | Consumer | 2830.63 | 308 |
| Troy Staebel | Consumer | 2820.42 | 309 |
| Gary Hansen | Home Office | 2819.47 | 310 |
| Barry Gonzalez | Consumer | 2798.95 | 311 |
| Trudy Brown | Consumer | 2797.67 | 312 |
| Robert Dilbeck | Home Office | 2786.63 | 313 |
| John Castell | Consumer | 2772.05 | 314 |
| Philip Fox | Consumer | 2770.0 | 315 |
| Emily Burns | Consumer | 2767.22 | 316 |
| Chris Selesnick | Corporate | 2754.22 | 317 |
| Michelle Moray | Consumer | 2749.88 | 318 |
| Ken Black | Corporate | 2744.74 | 319 |
| Lauren Leatherbury | Consumer | 2741.2 | 320 |
| Marc Crier | Consumer | 2725.98 | 321 |
| John Lucas | Consumer | 2725.26 | 322 |
| Marina Lichtenstein | Corporate | 2722.84 | 323 |
| Jay Kimmel | Consumer | 2709.63 | 324 |
| Justin Ellison | Corporate | 2697.25 | 325 |
| Bradley Talbott | Home Office | 2684.49 | 326 |
| Bill Overfelt | Corporate | 2682.73 | 327 |
| Frank Olsen | Consumer | 2678.44 | 328 |
| Nicole Hansen | Corporate | 2673.29 | 329 |
| Richard Bierner | Consumer | 2663.09 | 330 |
| Eva Jacobs | Consumer | 2656.69 | 331 |
| Dave Kipp | Consumer | 2650.56 | 332 |
| Christina Anderson | Consumer | 2648.29 | 333 |
| Logan Currie | Consumer | 2633.58 | 334 |
| Ralph Arnett | Consumer | 2617.91 | 335 |
| Katherine Nockton | Corporate | 2617.27 | 336 |
| Sean O'Donnell | Consumer | 2602.58 | 337 |
| Stephanie Ulpright | Home Office | 2595.36 | 338 |
| Helen Andreada | Consumer | 2584.16 | 339 |
| Alejandro Grove | Consumer | 2582.9 | 340 |
| Lena Cacioppo | Consumer | 2580.7 | 341 |
| Steve Chapman | Corporate | 2576.41 | 342 |
| Neola Schneider | Consumer | 2575.86 | 343 |
| Beth Thompson | Home Office | 2567.66 | 344 |
| Eleni McCrary | Corporate | 2567.01 | 345 |
| Mary Zewe | Corporate | 2564.91 | 346 |
| Bruce Stewart | Consumer | 2562.38 | 347 |
| Deanra Eno | Home Office | 2550.87 | 348 |
| Corey Catlett | Corporate | 2540.63 | 349 |
| Ann Chong | Corporate | 2537.69 | 350 |
| Charles McCrossin | Consumer | 2533.31 | 351 |
| Herbert Flentye | Consumer | 2533.16 | 352 |
| Fred McMath | Consumer | 2523.27 | 353 |
| Julia Barnett | Home Office | 2518.12 | 354 |
| Joy Smith | Consumer | 2516.49 | 355 |
| Don Jones | Corporate | 2501.69 | 356 |
| Amy Hunt | Consumer | 2495.39 | 357 |
| Patrick O'Donnell | Consumer | 2493.21 | 358 |
| Nick Zandusky | Home Office | 2488.31 | 359 |
| Michael Nguyen | Consumer | 2477.95 | 360 |
| Beth Paige | Consumer | 2475.16 | 361 |
| Charles Crestani | Consumer | 2471.65 | 362 |
| Nat Carroll | Consumer | 2461.4 | 363 |
| Filia McAdams | Corporate | 2456.64 | 364 |
| Mark Hamilton | Consumer | 2456.18 | 365 |
| Brendan Sweed | Corporate | 2454.93 | 366 |
| Valerie Mitchum | Home Office | 2454.87 | 367 |
| George Zrebassa | Corporate | 2454.62 | 368 |
| Michelle Arnett | Home Office | 2453.28 | 369 |
| Bart Pistole | Corporate | 2442.04 | 370 |
| Matt Collister | Corporate | 2426.07 | 371 |
| Thea Hendricks | Consumer | 2422.82 | 372 |
| Marc Harrigan | Home Office | 2394.03 | 373 |
| David Flashing | Consumer | 2390.53 | 374 |
| Xylona Preis | Consumer | 2374.66 | 375 |
| Clytie Kelty | Consumer | 2372.75 | 376 |
| Jennifer Ferguson | Consumer | 2371.45 | 377 |
| Cynthia Voltz | Corporate | 2370.31 | 378 |
| Nick Radford | Consumer | 2367.28 | 379 |
| Jack Garza | Consumer | 2358.68 | 380 |
| Andrew Gjertsen | Corporate | 2356.86 | 381 |
| Craig Leslie | Home Office | 2353.59 | 382 |
| Maureen Gastineau | Home Office | 2350.19 | 383 |
| Roland Fjeld | Consumer | 2341.3 | 384 |
| Elizabeth Moffitt | Corporate | 2339.6 | 385 |
| Dean Braden | Consumer | 2332.58 | 386 |
| Chris McAfee | Consumer | 2305.71 | 387 |
| Michael Kennedy | Corporate | 2302.37 | 388 |
| Lena Hernandez | Consumer | 2295.33 | 389 |
| Kristina Nunn | Home Office | 2280.58 | 390 |
| Jamie Frazer | Consumer | 2279.59 | 391 |
| Fred Harton | Consumer | 2271.28 | 392 |
| Craig Carreira | Consumer | 2269.7 | 393 |
| Bobby Elias | Consumer | 2261.44 | 394 |
| Kalyca Meade | Corporate | 2260.96 | 395 |
| Matt Connell | Corporate | 2258.19 | 396 |
| Justin Hirsh | Consumer | 2256.39 | 397 |
| Maribeth Yedwab | Corporate | 2254.28 | 398 |
| Ken Dana | Corporate | 2243.51 | 399 |
| Tony Sayre | Consumer | 2243.27 | 400 |
| Jason Gross | Corporate | 2240.58 | 401 |
| Laurel Workman | Corporate | 2238.06 | 402 |
| Allen Rosenblatt | Corporate | 2236.13 | 403 |
| Greg Guthrie | Corporate | 2224.0 | 404 |
| Nathan Cano | Consumer | 2218.99 | 405 |
| Mick Crebagga | Consumer | 2218.98 | 406 |
| Dave Poirier | Corporate | 2215.0 | 407 |
| Phillip Flathmann | Consumer | 2206.13 | 408 |
| Maya Herman | Corporate | 2203.78 | 409 |
| Janet Lee | Consumer | 2203.7 | 410 |
| Justin Ritter | Corporate | 2201.69 | 411 |
| Edward Nazzal | Consumer | 2199.37 | 412 |
| Toby Braunhardt | Consumer | 2198.45 | 413 |
| Giulietta Weimer | Consumer | 2189.02 | 414 |
| Bill Tyler | Corporate | 2186.61 | 415 |
| Pamela Stobb | Consumer | 2181.48 | 416 |
| Shahid Hopkins | Consumer | 2180.72 | 417 |
| Kean Nguyen | Corporate | 2171.96 | 418 |
| Daniel Byrd | Home Office | 2171.6 | 419 |
| Roy Phan | Corporate | 2170.72 | 420 |
| Theresa Swint | Corporate | 2163.62 | 421 |
| Helen Abelman | Consumer | 2163.3 | 422 |
| Ed Jacobs | Consumer | 2162.17 | 423 |
| Neoma Murray | Consumer | 2161.98 | 424 |
| John Dryer | Consumer | 2152.35 | 425 |
| Clay Rozendal | Home Office | 2148.85 | 426 |
| Duane Noonan | Consumer | 2139.79 | 427 |
| Karen Carlisle | Corporate | 2120.95 | 428 |
| Stefanie Holloman | Corporate | 2096.39 | 429 |
| Liz Carlisle | Consumer | 2095.06 | 430 |
| Rob Haberlin | Consumer | 2085.74 | 431 |
| Trudy Glocke | Consumer | 2074.66 | 432 |
| Max Ludwig | Home Office | 2071.91 | 433 |
| Roger Barcio | Home Office | 2067.45 | 434 |
| Tom Stivers | Corporate | 2054.14 | 435 |
| Art Ferguson | Consumer | 2052.91 | 436 |
| Carlos Daly | Consumer | 2033.97 | 437 |
| Nicole Fjeld | Home Office | 2031.47 | 438 |
| Denny Joy | Corporate | 2012.52 | 439 |
| Victoria Brennan | Corporate | 2005.6 | 440 |
| Harold Pawlan | Home Office | 1990.31 | 441 |
| Doug Bickford | Consumer | 1989.05 | 442 |
| Paul Gonzalez | Consumer | 1987.16 | 443 |
| Nona Balk | Corporate | 1972.6 | 444 |
| Scott Williamson | Consumer | 1966.65 | 445 |
| Lisa DeCherney | Consumer | 1961.93 | 446 |
| Christy Brittain | Consumer | 1949.2 | 447 |
| Tracy Poddar | Corporate | 1936.64 | 448 |
| Jas O'Carroll | Consumer | 1934.27 | 449 |
| Jay Fein | Consumer | 1911.84 | 450 |
| Max Engle | Consumer | 1908.45 | 451 |
| Susan Vittorini | Consumer | 1903.49 | 452 |
| Katherine Ducich | Consumer | 1888.96 | 453 |
| Giulietta Dortch | Corporate | 1888.07 | 454 |
| Sheri Gordon | Consumer | 1884.8 | 455 |
| Lisa Ryan | Corporate | 1879.31 | 456 |
| Shaun Chance | Corporate | 1875.0 | 457 |
| Brooke Gillingham | Corporate | 1874.17 | 458 |
| Stephanie Phelps | Corporate | 1872.44 | 459 |
| Nat Gilpin | Corporate | 1869.58 | 460 |
| Cynthia Delaney | Home Office | 1860.73 | 461 |
| Skye Norling | Home Office | 1860.42 | 462 |
| Patrick Ryan | Consumer | 1840.18 | 463 |
| Ashley Jarboe | Consumer | 1839.24 | 464 |
| Pamela Coakley | Corporate | 1832.06 | 465 |
| Emily Grady | Consumer | 1832.02 | 466 |
| Pauline Johnson | Consumer | 1824.23 | 467 |
| Noah Childs | Corporate | 1821.74 | 468 |
| Janet Molinari | Corporate | 1804.15 | 469 |
| Jennifer Braxton | Corporate | 1791.61 | 470 |
| Andrew Allen | Consumer | 1790.51 | 471 |
| Chad Cunningham | Home Office | 1770.94 | 472 |
| Darrin Sayre | Home Office | 1762.21 | 473 |
| Monica Federle | Corporate | 1758.3 | 474 |
| Aaron Hawkins | Corporate | 1744.7 | 475 |
| Logan Haushalter | Consumer | 1739.69 | 476 |
| Ben Wallace | Consumer | 1738.41 | 477 |
| Valerie Takahito | Home Office | 1736.6 | 478 |
| Adrian Hane | Home Office | 1735.51 | 479 |
| Mike Vittorini | Consumer | 1734.57 | 480 |
| Jessica Myrick | Consumer | 1733.44 | 481 |
| Brad Eason | Home Office | 1727.65 | 482 |
| Denny Blanton | Consumer | 1711.69 | 483 |
| Julie Prescott | Home Office | 1707.71 | 484 |
| Tracy Zic | Consumer | 1707.29 | 485 |
| Becky Pak | Consumer | 1697.86 | 486 |
| Darren Koutras | Consumer | 1687.04 | 487 |
| Meg O'Connel | Home Office | 1687.03 | 488 |
| Ryan Akin | Consumer | 1686.92 | 489 |
| Katrina Edelman | Corporate | 1686.73 | 490 |
| Cathy Armstrong | Home Office | 1679.72 | 491 |
| Candace McMahon | Corporate | 1673.89 | 492 |
| Jennifer Patt | Corporate | 1669.13 | 493 |
| Chad McGuire | Consumer | 1661.61 | 494 |
| Cindy Chapman | Consumer | 1659.44 | 495 |
| Erica Bern | Corporate | 1643.26 | 496 |
| Anne Pryor | Home Office | 1638.55 | 497 |
| Annie Zypern | Consumer | 1622.02 | 498 |
| Maurice Satty | Consumer | 1613.4 | 499 |
| Tim Brockman | Consumer | 1602.38 | 500 |
| Craig Reiter | Consumer | 1600.55 | 501 |
| Alan Haines | Corporate | 1587.45 | 502 |
| Benjamin Farhat | Home Office | 1585.16 | 503 |
| Cyma Kinney | Corporate | 1582.11 | 504 |
| Mike Caudle | Corporate | 1582.0 | 505 |
| James Lanier | Home Office | 1571.52 | 506 |
| Karl Braun | Consumer | 1569.46 | 507 |
| George Bell | Corporate | 1568.44 | 508 |
| Odella Nelson | Corporate | 1567.52 | 509 |
| Mark Van Huff | Consumer | 1560.05 | 510 |
| Maria Bertelson | Consumer | 1548.7 | 511 |
| Brian DeCherney | Consumer | 1538.11 | 512 |
| Cathy Hwang | Home Office | 1537.24 | 513 |
| Bruce Degenhardt | Consumer | 1526.5 | 514 |
| Benjamin Venier | Corporate | 1523.27 | 515 |
| Kelly Andreada | Consumer | 1519.51 | 516 |
| Ann Blume | Corporate | 1515.86 | 517 |
| John Grady | Corporate | 1507.02 | 518 |
| Dan Lawera | Consumer | 1503.11 | 519 |
| Zuschuss Donatelli | Consumer | 1493.94 | 520 |
| Charlotte Melton | Consumer | 1475.14 | 521 |
| Laurel Elliston | Consumer | 1469.45 | 522 |
| Ted Butterfield | Consumer | 1467.88 | 523 |
| Parhena Norris | Home Office | 1467.15 | 524 |
| Ralph Kennedy | Consumer | 1460.19 | 525 |
| Bradley Nguyen | Consumer | 1459.34 | 526 |
| Delfina Latchford | Consumer | 1458.26 | 527 |
| Philip Brown | Consumer | 1456.95 | 528 |
| Andy Gerbode | Corporate | 1455.04 | 529 |
| Raymond Messe | Consumer | 1453.47 | 530 |
| Paul Knutson | Home Office | 1441.15 | 531 |
| Tamara Dahlen | Consumer | 1434.55 | 532 |
| Julia West | Consumer | 1428.73 | 533 |
| Mick Brown | Consumer | 1428.23 | 534 |
| Thomas Thornton | Consumer | 1427.04 | 535 |
| Christine Abelman | Corporate | 1421.95 | 536 |
| Roger Demir | Consumer | 1419.74 | 537 |
| Nancy Lomonaco | Home Office | 1418.09 | 538 |
| Jill Stevenson | Corporate | 1417.65 | 539 |
| Paul MacIntyre | Consumer | 1405.4 | 540 |
| Guy Armstrong | Consumer | 1398.38 | 541 |
| Cyra Reiten | Home Office | 1397.87 | 542 |
| Nathan Gelder | Consumer | 1395.94 | 543 |
| Jeremy Ellison | Consumer | 1388.68 | 544 |
| Troy Blackwell | Consumer | 1387.56 | 545 |
| Frank Gastineau | Home Office | 1383.14 | 546 |
| Don Miller | Corporate | 1376.79 | 547 |
| Gene Hale | Corporate | 1361.24 | 548 |
| Sarah Bern | Consumer | 1348.02 | 549 |
| Liz MacKendrick | Consumer | 1346.77 | 550 |
| Maureen Gnade | Consumer | 1342.28 | 551 |
| Sarah Jordon | Consumer | 1341.04 | 552 |
| Bryan Mills | Consumer | 1338.84 | 553 |
| Barry Franz | Home Office | 1333.88 | 554 |
| Saphhira Shifley | Corporate | 1324.03 | 555 |
| Dario Medina | Corporate | 1322.03 | 556 |
| Michelle Tran | Home Office | 1319.45 | 557 |
| Shirley Jackson | Consumer | 1318.78 | 558 |
| Magdelene Morse | Consumer | 1314.02 | 559 |
| Sibella Parks | Corporate | 1306.09 | 560 |
| Matt Collins | Consumer | 1303.89 | 561 |
| Eileen Kiefer | Home Office | 1303.48 | 562 |
| Corey-Lock | Consumer | 1300.08 | 563 |
| Denny Ordway | Consumer | 1300.03 | 564 |
| Hallie Redmond | Home Office | 1299.29 | 565 |
| Georgia Rosenberg | Corporate | 1284.38 | 566 |
| Cari Sayre | Corporate | 1278.95 | 567 |
| Paul Stevenson | Home Office | 1278.64 | 568 |
| Stuart Van | Corporate | 1271.09 | 569 |
| Doug O'Connell | Consumer | 1267.32 | 570 |
| Carl Ludwig | Consumer | 1262.01 | 571 |
| Liz Willingham | Consumer | 1259.04 | 572 |
| Michelle Ellison | Corporate | 1256.94 | 573 |
| Gene McClure | Consumer | 1255.68 | 574 |
| Steve Carroll | Home Office | 1254.64 | 575 |
| Matt Hagelstein | Corporate | 1252.8 | 576 |
| Elpida Rittenbach | Corporate | 1245.79 | 577 |
| Tony Chapman | Home Office | 1244.98 | 578 |
| Joni Wasserman | Consumer | 1244.09 | 579 |
| Michael Grace | Home Office | 1242.83 | 580 |
| Nora Pelletier | Home Office | 1228.7 | 581 |
| Patrick Jones | Corporate | 1220.09 | 582 |
| Erica Hernandez | Home Office | 1219.53 | 583 |
| Jack Lebron | Consumer | 1214.96 | 584 |
| Christina DeMoss | Consumer | 1205.58 | 585 |
| Michael Dominguez | Corporate | 1204.91 | 586 |
| Dorothy Wardle | Corporate | 1204.85 | 587 |
| Evan Bailliet | Consumer | 1186.33 | 588 |
| Benjamin Patterson | Consumer | 1181.49 | 589 |
| Debra Catini | Consumer | 1174.62 | 590 |
| Alyssa Tate | Home Office | 1171.81 | 591 |
| Jim Radford | Consumer | 1156.66 | 592 |
| Duane Benoit | Consumer | 1155.2 | 593 |
| Claire Gute | Consumer | 1148.78 | 594 |
| Kimberly Carter | Corporate | 1146.05 | 595 |
| Ross DeVincentis | Home Office | 1137.62 | 596 |
| Carl Weiss | Home Office | 1136.59 | 597 |
| Jim Sink | Corporate | 1131.06 | 598 |
| Darrin Van Huff | Corporate | 1119.48 | 599 |
| Alan Barnes | Consumer | 1113.84 | 600 |
| Tony Molinari | Consumer | 1094.68 | 601 |
| Jesus Ocampo | Home Office | 1090.84 | 602 |
| Scot Wooten | Consumer | 1085.08 | 603 |
| Jeremy Farry | Consumer | 1082.92 | 604 |
| Dennis Bolton | Home Office | 1081.47 | 605 |
| David Wiener | Corporate | 1080.75 | 606 |
| Cindy Schnelling | Corporate | 1077.23 | 607 |
| Pauline Chand | Home Office | 1061.49 | 608 |
| David Philippe | Consumer | 1058.62 | 609 |
| Jenna Caffey | Consumer | 1058.11 | 610 |
| Phillina Ober | Home Office | 1056.86 | 611 |
| Allen Armold | Consumer | 1056.39 | 612 |
| Vivek Sundaresam | Consumer | 1055.98 | 613 |
| Alex Russell | Corporate | 1055.69 | 614 |
| Darren Powers | Consumer | 1050.64 | 615 |
| Duane Huffman | Home Office | 1043.1 | 616 |
| Susan MacKendrick | Consumer | 1043.04 | 617 |
| Eudokia Martin | Corporate | 1041.04 | 618 |
| Theresa Coyne | Corporate | 1038.26 | 619 |
| Mike Kennedy | Consumer | 1031.6 | 620 |
| Tiffany House | Corporate | 1022.2 | 621 |
| Sean Wendt | Home Office | 1019.04 | 622 |
| Luke Schmidt | Corporate | 1010.26 | 623 |
| Randy Bradley | Consumer | 1008.2 | 624 |
| Lynn Smith | Consumer | 1008.14 | 625 |
| Bruce Geld | Consumer | 1006.36 | 626 |
| Victor Preis | Home Office | 993.9 | 627 |
| Ken Brennan | Corporate | 983.92 | 628 |
| Barry Pond | Corporate | 983.42 | 629 |
| Toby Swindell | Consumer | 974.78 | 630 |
| Russell D'Ascenzo | Consumer | 970.94 | 631 |
| Aimee Bixby | Consumer | 966.71 | 632 |
| Roy Collins | Consumer | 966.41 | 633 |
| Sung Shariari | Consumer | 964.64 | 634 |
| Jonathan Howell | Consumer | 959.48 | 635 |
| Jason Fortune- | Consumer | 955.12 | 636 |
| Rachel Payne | Corporate | 954.65 | 637 |
| Bryan Spruell | Home Office | 949.43 | 638 |
| Roy Französisch | Consumer | 945.22 | 639 |
| Eric Barreto | Consumer | 944.6 | 640 |
| Maureen Fritzler | Corporate | 937.04 | 641 |
| Eric Murdock | Consumer | 933.7 | 642 |
| Alyssa Crouse | Corporate | 925.8 | 643 |
| Evan Henry | Consumer | 923.88 | 644 |
| Mary O'Rourke | Consumer | 922.49 | 645 |
| Alejandro Ballentine | Home Office | 914.53 | 646 |
| Katrina Bavinger | Home Office | 908.82 | 647 |
| Catherine Glotzbach | Home Office | 904.47 | 648 |
| Sonia Cooley | Consumer | 902.73 | 649 |
| Joni Blumstein | Consumer | 900.55 | 650 |
| Henia Zydlo | Consumer | 886.52 | 651 |
| Aaron Bergman | Consumer | 886.16 | 652 |
| Ryan Crowe | Consumer | 885.75 | 653 |
| Chad Sievert | Consumer | 884.64 | 654 |
| Harold Engle | Corporate | 883.53 | 655 |
| Sally Knutson | Consumer | 883.41 | 656 |
| Richard Eichhorn | Consumer | 876.7 | 657 |
| Jim Mitchum | Corporate | 864.95 | 658 |
| Jocasta Rupert | Consumer | 863.88 | 659 |
| Art Foster | Consumer | 861.56 | 660 |
| Julie Creighton | Corporate | 858.58 | 661 |
| Michael Stewart | Corporate | 855.12 | 662 |
| Vicky Freymann | Home Office | 847.94 | 663 |
| Vivek Gonzalez | Consumer | 846.01 | 664 |
| Charles Sheldon | Corporate | 844.46 | 665 |
| Todd Boyes | Corporate | 834.33 | 666 |
| Ann Steele | Home Office | 833.4 | 667 |
| Erica Hackney | Consumer | 825.95 | 668 |
| Thomas Brumley | Home Office | 816.17 | 669 |
| Alice McCarthy | Corporate | 814.01 | 670 |
| Brendan Murry | Corporate | 808.16 | 671 |
| David Kendrick | Corporate | 797.83 | 672 |
| Matthew Clasen | Corporate | 795.15 | 673 |
| Beth Fritzler | Corporate | 791.99 | 674 |
| Harry Greene | Consumer | 785.63 | 675 |
| Michael Granlund | Home Office | 776.38 | 676 |
| Muhammed MacIntyre | Corporate | 775.41 | 677 |
| Sandra Flanagan | Consumer | 763.55 | 678 |
| Steven Ward | Corporate | 758.7 | 679 |
| Liz Pelletier | Consumer | 756.61 | 680 |
| Dorris liebe | Corporate | 755.6 | 681 |
| Ivan Gibson | Consumer | 744.57 | 682 |
| Barry Blumstein | Corporate | 744.34 | 683 |
| Tracy Collins | Home Office | 742.56 | 684 |
| Michelle Lonsdale | Corporate | 742.08 | 685 |
| Ritsa Hightower | Consumer | 740.38 | 686 |
| Patrick Bzostek | Home Office | 740.36 | 687 |
| Angele Hood | Consumer | 738.5 | 688 |
| Henry MacAllister | Consumer | 736.28 | 689 |
| Patricia Hirasaki | Home Office | 729.65 | 690 |
| Pete Armstrong | Home Office | 729.41 | 691 |
| Jennifer Jackson | Consumer | 709.18 | 692 |
| Julia Dunbar | Consumer | 695.44 | 693 |
| Peter Bühler | Consumer | 688.32 | 694 |
| Eric Hoffmann | Consumer | 684.17 | 695 |
| Toby Ritter | Consumer | 675.94 | 696 |
| Alex Grayson | Consumer | 660.97 | 697 |
| Berenike Kampe | Consumer | 659.14 | 698 |
| Bryan Davis | Consumer | 658.47 | 699 |
| Anna Chung | Consumer | 657.32 | 700 |
| Anthony Witt | Consumer | 649.38 | 701 |
| Lori Olson | Corporate | 644.35 | 702 |
| Joy Bell- | Consumer | 644.12 | 703 |
| Carol Darley | Consumer | 639.77 | 704 |
| Mathew Reese | Home Office | 639.18 | 705 |
| Astrea Jones | Consumer | 629.25 | 706 |
| Ralph Ritter | Consumer | 615.93 | 707 |
| Shirley Schmidt | Home Office | 613.4 | 708 |
| Bobby Trafton | Consumer | 603.88 | 709 |
| Barbara Fisher | Corporate | 599.8 | 710 |
| Maria Zettner | Home Office | 593.61 | 711 |
| Denise Leinenbach | Consumer | 585.02 | 712 |
| Alan Shonely | Consumer | 584.61 | 713 |
| Brian Derr | Consumer | 582.65 | 714 |
| Neil Knudson | Home Office | 572.05 | 715 |
| Carlos Meador | Consumer | 565.39 | 716 |
| Chuck Sachs | Consumer | 550.64 | 717 |
| Cari Schnelling | Consumer | 537.63 | 718 |
| John Huston | Consumer | 528.91 | 719 |
| Rob Beeghly | Consumer | 528.55 | 720 |
| Andy Yotov | Corporate | 497.01 | 721 |
| Corey Roper | Home Office | 475.9 | 722 |
| MaryBeth Skach | Consumer | 475.66 | 723 |
| Joni Sundaresam | Home Office | 469.17 | 724 |
| Erin Creighton | Consumer | 461.91 | 725 |
| Khloe Miller | Consumer | 453.54 | 726 |
| Kelly Williams | Consumer | 449.1 | 727 |
| Tim Taslimi | Corporate | 439.5 | 728 |
| Shui Tom | Consumer | 433.34 | 729 |
| Vivek Grady | Corporate | 427.37 | 730 |
| Sonia Sunley | Consumer | 418.49 | 731 |
| Brad Thomas | Home Office | 415.2 | 732 |
| Mark Haberlin | Corporate | 400.02 | 733 |
| Barry Weirich | Consumer | 385.52 | 734 |
| Joy Daniels | Consumer | 385.43 | 735 |
| Jason Klamczynski | Corporate | 383.81 | 736 |
| Vivian Mathis | Consumer | 380.69 | 737 |
| Neil Französisch | Home Office | 377.16 | 738 |
| Melanie Seite | Consumer | 370.35 | 739 |
| Lycoris Saunders | Consumer | 368.88 | 740 |
| Aleksandra Gannaway | Corporate | 367.55 | 741 |
| Evan Minnotte | Home Office | 366.82 | 742 |
| Heather Jas | Home Office | 358.1 | 743 |
| Don Weiss | Consumer | 344.08 | 744 |
| Larry Tron | Consumer | 329.88 | 745 |
| Brendan Dodson | Home Office | 320.54 | 746 |
| Lisa Hazard | Consumer | 318.24 | 747 |
| Jennifer Halladay | Consumer | 309.28 | 748 |
| Jill Matthias | Consumer | 303.95 | 749 |
| Chuck Magee | Consumer | 287.99 | 750 |
| Larry Hughes | Consumer | 287.43 | 751 |
| Sung Chung | Consumer | 280.63 | 752 |
| Stuart Calhoun | Consumer | 279.26 | 753 |
| Nicole Brennan | Corporate | 273.87 | 754 |
| Bart Folk | Consumer | 272.95 | 755 |
| Dorothy Dickinson | Consumer | 269.54 | 756 |
| Brad Norvell | Corporate | 265.3 | 757 |
| Andrew Roberts | Consumer | 264.86 | 758 |
| Harold Dahlen | Home Office | 251.36 | 759 |
| Sally Matthias | Consumer | 244.49 | 760 |
| Paul Lucas | Home Office | 239.48 | 761 |
| Guy Phonely | Corporate | 236.53 | 762 |
| Erin Mull | Consumer | 228.99 | 763 |
| Guy Thornton | Consumer | 226.44 | 764 |
| Robert Barroso | Corporate | 221.08 | 765 |
| Hilary Holden | Corporate | 218.67 | 766 |
| Allen Goldenen | Consumer | 200.94 | 767 |
| Joel Jenkins | Home Office | 195.0 | 768 |
| Anthony Garverick | Home Office | 170.58 | 769 |
| Muhammed Lee | Consumer | 162.23 | 770 |
| Anthony O'Donnell | Corporate | 161.28 | 771 |
| Pete Takahito | Consumer | 160.57 | 772 |
| Dianna Arnett | Home Office | 156.76 | 773 |
| Michael Oakman | Consumer | 154.29 | 774 |
| Greg Hansen | Consumer | 146.94 | 775 |
| Phillip Breyer | Corporate | 132.74 | 776 |
| Bobby Odegard | Consumer | 130.83 | 777 |
| Ed Ludwig | Home Office | 124.28 | 778 |
| Clay Cheatham | Consumer | 113.83 | 779 |
| Roland Murray | Consumer | 98.35 | 780 |
| Karen Seio | Corporate | 88.47 | 781 |
| Anemone Ratner | Consumer | 88.15 | 782 |
| Fred Wasserman | Corporate | 79.75 | 783 |
| Jasper Cacioppo | Consumer | 71.26 | 784 |
| Adrian Shami | Home Office | 58.82 | 785 |
| Larry Blacks | Consumer | 50.19 | 786 |
| Ricardo Emerson | Consumer | 48.36 | 787 |
| Susan Gilcrest | Corporate | 47.95 | 788 |
| Roy Skaria | Home Office | 22.33 | 789 |
| Mitch Gastineau | Corporate | 16.74 | 790 |
| Carl Jackson | Corporate | 16.52 | 791 |
| Lela Donovan | Corporate | 5.3 | 792 |
| Thais Sissman | Consumer | 4.83 | 793 |

**Detailed Business Insight:**

- **End-to-End Customer Classification:** By combining relational JOINs (joining `customers` and `orders`), CTE-level aggregations, and Analytical Window Functions, we construct a comprehensive ranking system.
- **Macro Trends:** The Consumer segment has the highest count of customer accounts in the upper ranks, but the Home Office and Corporate segments occupy the absolute top revenue-driving ranks, proving the high financial impact of business customers.

### Query 2: Top Customers (Top 10 by total sales)

```sql
-- Query 2: Top Customers (Top 10 by total sales)
WITH customer_sales AS (
    SELECT 
        customer_id,
        SUM(sales) AS total_sales
    FROM 
        orders
    GROUP BY 
        customer_id
)
SELECT 
    c.customer_id,
    c.customer_name,
    ROUND(cs.total_sales, 2) AS total_sales
FROM 
    customers c
JOIN 
    customer_sales cs ON c.customer_id = cs.customer_id
ORDER BY 
    cs.total_sales DESC
LIMIT 10
```

#### Results:

| customer_id | customer_name | total_sales |
| --- | --- | --- |
| SM-20320 | Sean Miller | 25043.05 |
| TC-20980 | Tamara Chand | 19052.22 |
| RB-19360 | Raymond Buch | 15117.34 |
| TA-21385 | Tom Ashbrook | 14595.62 |
| AB-10105 | Adrian Barton | 14473.57 |
| KL-16645 | Ken Lonsdale | 14175.23 |
| SC-20095 | Sanjit Chand | 14142.33 |
| HL-15040 | Hunter Lopez | 12873.3 |
| SE-20110 | Sanjit Engle | 12209.44 |
| CC-12370 | Christopher Conant | 12129.07 |

**Detailed Business Insight:**

- **Revenue Concentration:** The top 10 customers drive a disproportionate share of the store's overall revenue. The top customer (Sean Miller) has generated over $25,000 in sales, which is 54 times the average order value.
- **Customer Loyalty Program:** These top 10 accounts represent key value drivers. The business should enroll these customers in VIP accounts with dedicated managers, faster shipping, and volume discount structures to defend them from competitor acquisition.

### Query 3: Low Customers (Bottom 10 by total sales)

```sql
-- Query 3: Low Customers (Bottom 10 by total sales)
WITH customer_sales AS (
    SELECT 
        customer_id,
        SUM(sales) AS total_sales
    FROM 
        orders
    GROUP BY 
        customer_id
)
SELECT 
    c.customer_id,
    c.customer_name,
    ROUND(cs.total_sales, 2) AS total_sales
FROM 
    customers c
JOIN 
    customer_sales cs ON c.customer_id = cs.customer_id
ORDER BY 
    cs.total_sales ASC
LIMIT 10
```

#### Results:

| customer_id | customer_name | total_sales |
| --- | --- | --- |
| TS-21085 | Thais Sissman | 4.83 |
| LD-16855 | Lela Donovan | 5.3 |
| CJ-11875 | Carl Jackson | 16.52 |
| MG-18205 | Mitch Gastineau | 16.74 |
| RS-19870 | Roy Skaria | 22.33 |
| SG-20890 | Susan Gilcrest | 47.95 |
| RE-19405 | Ricardo Emerson | 48.36 |
| LB-16735 | Larry Blacks | 50.19 |
| AS-10135 | Adrian Shami | 58.82 |
| JC-15340 | Jasper Cacioppo | 71.26 |

**Detailed Business Insight:**

- **Low-Value Account Profile:** The bottom 10 customers have cumulative spends under $100. For example, Thais Sissman spent only **$4.83** and Lela Donovan spent **$5.30**.
- **Re-engagement Opportunities:** These low figures could indicate immediate churn or that the customer was testing the service with a single trial purchase. Targeted email outreach offering high-value incentives or survey questions on customer satisfaction could help reactivate these dormant buyers.

### Query 4: Single-Order Customers (Customers who have placed only a single distinct order)

```sql
-- Query 4: Single-Order Customers (Customers who have placed only a single distinct order)
WITH customer_orders AS (
    SELECT 
        customer_id,
        COUNT(DISTINCT order_id) AS distinct_order_count
    FROM 
        orders
    GROUP BY 
        customer_id
)
SELECT 
    c.customer_id,
    c.customer_name,
    co.distinct_order_count AS total_orders
FROM 
    customers c
JOIN 
    customer_orders co ON c.customer_id = co.customer_id
WHERE 
    co.distinct_order_count = 1
```

#### Results:

| customer_id | customer_name | total_orders |
| --- | --- | --- |
| AO-10810 | Anthony O'Donnell | 1 |
| AR-10570 | Anemone Ratner | 1 |
| CJ-11875 | Carl Jackson | 1 |
| JC-15385 | Jenna Caffey | 1 |
| JR-15700 | Jocasta Rupert | 1 |
| LD-16855 | Lela Donovan | 1 |
| MG-18205 | Mitch Gastineau | 1 |
| PH-18790 | Patricia Hirasaki | 1 |
| RE-19405 | Ricardo Emerson | 1 |
| RM-19750 | Roland Murray | 1 |
| SM-20905 | Susan MacKendrick | 1 |
| TC-21145 | Theresa Coyne | 1 |

**Detailed Business Insight:**

- **Customer Churn Risk:** The query identifies 12 customers who placed only one distinct order. High single-order customer counts indicate high customer acquisition cost (CAC) relative to lifetime value (LTV).
- **Operational Interventions:** A customer who orders once and never returns represents friction in the product experience, delivery delays, or uncompetitive pricing. Initiating a post-purchase feedback loop and sending automatic coupon triggers for their second purchase are recommended solutions.

### Query 5: Above-Average Order Total Sales

```sql
-- Query 5: Above-Average Order Total Sales
-- Finds orders where the SUM of sales for that order ID is greater than the average order total across all orders.
WITH order_totals AS (
    SELECT 
        order_id,
        SUM(sales) AS total_sales
    FROM 
        orders
    GROUP BY 
        order_id
),
average_order_value AS (
    SELECT 
        AVG(total_sales) AS avg_sales
    FROM 
        order_totals
)
SELECT 
    ot.order_id,
    ROUND(ot.total_sales, 2) AS total_sales,
    ROUND(aov.avg_sales, 2) AS average_order_sales
FROM 
    order_totals ot
CROSS JOIN 
    average_order_value aov
WHERE 
    ot.total_sales > aov.avg_sales
ORDER BY 
    ot.total_sales DESC
LIMIT 10
```

#### Results:

| order_id | total_sales | average_order_sales |
| --- | --- | --- |
| CA-2014-145317 | 23661.23 | 458.61 |
| CA-2016-118689 | 18336.74 | 458.61 |
| CA-2017-140151 | 14052.48 | 458.61 |
| CA-2017-127180 | 13716.46 | 458.61 |
| CA-2014-139892 | 10539.9 | 458.61 |
| CA-2017-166709 | 10499.97 | 458.61 |
| CA-2014-116904 | 9900.19 | 458.61 |
| CA-2016-117121 | 9892.74 | 458.61 |
| US-2016-107440 | 9135.19 | 458.61 |
| CA-2016-158841 | 8805.04 | 458.61 |

**Detailed Business Insight:**

- **Order Value Dynamics:** The average total value of an entire order is **$458.61**. The top orders return values exceeding thousands of dollars (e.g., CA-2014-145317 total order sales are **$23,661.23**, which is 51x the average order total).
- **Operational Impact:** Large order baskets require specialized inventory warehousing and bulk logistics coordination. High average orders indicate that while the superstore has many retail consumers, its primary economic engine is high-volume wholesale/commercial orders.

