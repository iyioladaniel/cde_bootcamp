--Calculate percentage and number of accounts per region
With split AS (
SELECT r.name region, COUNT(a.name) number_of_accounts, SUM(o.total_amt_usd) total--, COUNT(a.name)/ 
FROM sales_reps sr
	JOIN region r ON sr.region_id = r.id
	JOIN accounts a ON sr.id = a.sales_rep_id
	JOIN orders o ON a.id = o.account_id
GROUP BY r.name),
total AS (SELECT COUNT(1) total_count FROM accounts)
SELECT split.region, split.number_of_accounts, 
		(CAST(split.number_of_accounts AS DECIMAL(10,2))/total.total_count)* 100 percentage, split.total total_amt_usd
FROM split, total;

--Calculate total_amt_usd for the first 3 regions
SELECT SUM(o.total_amt_usd) total
FROM sales_reps sr
	JOIN region r ON sr.region_id = r.id
	JOIN accounts a ON sr.id = a.sales_rep_id
	JOIN orders o ON a.id = o.account_id
WHERE r.name IN ('Northeast','Southeast','West');
-- 20,128,025.32

--Total revenue for the company
SELECT SUM(total_amt_usd) total
FROM orders;
--23,141,511.83

--
SELECT we.channel, COUNT(o.id) count_of_orders, SUM(total_amt_usd) total_amt_usd 
FROM web_events we
	--JOIN accounts a ON we.account_id = a.id
	JOIN orders o ON o.account_id = we.account_id -- = a.id
GROUP BY we.channel;

/*
channel		count_of_orders	total
"twitter"	15,992	50,666,690.69
"adwords"	30,142	97,776,855.64
"organic"	32,228	102,050,326.78
"banner"	15,634	48,078,404.05
"facebook"	32,251	103,030,656.98
"direct"	195,236	639,699,777.26
*/

