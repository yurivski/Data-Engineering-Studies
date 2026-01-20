# SQL - PostgreSQL: Execution Order

## Memorizing vs. Understanding

During my studies transitioning to data engineering – in SQL language, from the beginning it intrigued me to know how everything worked, why it worked, why "this" has to be "here" and "that" has to be "there".

So when I was studying the basics, this thought came to my mind. I believe that normally when someone is starting, the first thing the person wants is to memorize the order to write a query, because it is common to get confused, like using ORDER BY before GROUP BY, or sometimes getting psyched and writing WHERE before FROM.

When we memorize that a query is written in the order:
```sql
1. SELECT / DISTINCT
2. FROM / JOIN
3. WHERE
4. GROUP BY
5. HAVING
6. ORDER BY
7. LIMIT
```

We begin to ask: "Why this order? Is the code executed in this same order?".

---

## Write order ≠ Execution order

And it is not quite like that, the execution order is completely different from the write order, and understanding this made me more assertive when writing a query, no matter how basic it is and especially the more complex ones. I particularly start writing a query by the execution order, because it is easier to maintain the reasoning when writing a more complex query, for example:
```sql
1. FROM / JOIN
2. WHERE
3. GROUP BY
4. HAVING
5. SELECT / DISTINCT
6. ORDER BY
7. LIMIT.
```

First PostgreSQL reads the table data and loads it into memory (buffer pool), then the row, then groups everything to be able to filter, then calculates and selects what was filtered, after that eliminates duplicate rows, puts the table reading in order and limits the rows that will be displayed to show the query.

I learned in practice that we should always limit the amount of rows to be displayed in a query with a large database, the amount of memory used to process all this, depending on the number of records, is very large and limiting this saves you time.

---

## How this changes everything

It happens that, the write order will be compiled by PostgreSQL and transformed into an execution plan. Next, this plan will be executed to process the data according to the query logic, and the table data will be read into the memory of the server on which the database is running (we can visualize this plan using the EXPLAIN ANALYZE command). Finally, it will start processing the data.

Therefore, when it comes to execution, it will start with the FROM clause, the data will be read from the table into memory and then it will apply the conditions of the WHERE clause.

If the table has 1,000 rows and PostgreSQL performs a sequential scan (no indexes), all 1,000 rows will be read into memory. After that, the data will be filtered and the intermediate results will be stored in memory again. It does not matter the amount of records: if we are querying 3 records in the WHERE clause, these 3 records will be placed in memory; if the same condition returns 100 out of 1,000 records from the table, these 100 records will be stored in memory again.

However, if there are indexes on the WHERE columns, PostgreSQL may use an index scan to read only the necessary rows directly, which is much more efficient.

So, all filtered data will be made available to us in memory after the WHERE clause, which will execute everything inside GROUP BY.

Normally as part of GROUP BY, we specify the keys (PK or FK) on which the data should be grouped in the SELECT clause, we can also have aggregation functions in the SELECT clause in addition to executing the logic in a GROUP BY that will also execute what is in the SELECT clause.

As there will often be dependencies between the two, PostgreSQL will process in an integrated way: GROUP BY prepares the groups, and SELECT calculates the aggregations (COUNT, SUM, AVG, etc) on top of these groups, from there, PostgreSQL executes the additional filters (HAVING) or goes straight to the ordering of the results (ORDER BY), depending on the query we are doing.

It classifies the data again after grouping by the key to perform the aggregation, so we have ORDER BY classifying the output and returning the results according to the logic.

It is good to remember that filters also have an order, the WHERE clause filters the rows before grouping, the HAVING expression filters after grouping. Understanding this gives us a processing advantage, because filtering the rows (WHERE -> FILTER -> GROUP BY) is faster than filtering a grouping (GROUP BY -> AGGREGATE -> HAVING: filters groups).

![Alternative text](./assets/images/execution_order.png)

---

## Full Mind Map

For an interactive and detailed view of the entire SQL execution order, check out the complete mind map:

[![Full Mind Map: SQL - PostgreSQL Execution Order](https://www.mindmeister.com/image/xlarge/3919214140/mind-map-sql-postgresql-execution-order.png)](https://www.mindmeister.com/3919214140/sql-postgresql-execution-order)

*Click on the image to open the interactive map in MindMeister*

---

---

## Practical example

Suppose we want to see the count of orders from a store by date, whose order status are "COMPLETE" and "CLOSED":
```sql
SELECT order_date, count(*) order_count -- Using aliases is not mandatory
FROM orders
WHERE order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1 -- Column (order_date)
ORDER BY 2 DESC LIMIT 10; -- Column (order_count)
```
![Alternative text](./assets/images/consulta_psql_1.png)

Or orders are "COMPLETE" and "CLOSED" above a certain value:
```sql
SELECT order_date, count(*) order_count
FROM orders
WHERE order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1
HAVING count(*) >= 120 -- Filter for values above 120 (example)
ORDER BY 2 DESC LIMIT 10;
```

To alias a column you do not necessarily need to use aliases (count). To summarize the query above:

1. we filter the count of orders from the orders table (FROM orders);
2. we identify the necessary rows, which filters only the records that exactly meet the criteria defined in parentheses, before performing the count (WHERE status IN ('COMPLETE', 'CLOSED'));
3. we group this filter according to the first column of SELECT (GROUP BY 1);
4. we order the results according to the second column of SELECT in descending order (ORDER BY 2 DESC;); and
5. we select the base column(s) of our query and temporarily create a new column that will show the result, with an alias (SELECT date, count(*) count).

The reason I used "1" and "2" in GROUP BY and ORDER BY is to simplify for me, normally we write the column names for greater clarity. "1" represents the first column of SELECT (date) and "2" the second column (count).

Understanding the concepts behind all code writing allows us to create ways to read, interpret, simplify, and if we can simplify something, it means we understand, and if we understand, we will not forget.

---

## Detailed practical example (EXPLAIN ANALYZE)

![Alternative text](./assets/images/explain_analyze_psql.png)

## Summarizing the EXPLAIN ANALYZE command (image):
```
Seq Scan: PostgreSQL read the entire table (38428 rows)
Filter: Applied WHERE, removed unwanted rows
HashAggregate: Grouped by order_date
Filter (HAVING): Removed 342 groups with count >= 120
Total time: ~21ms
```