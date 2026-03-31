SELECT T2.invoice_number ,  T2.invoice_date FROM Financial_transactions AS T1 JOIN Invoices AS T2 ON T1.invoice_number  =  T2.invoice_number GROUP BY T1.invoice_number ORDER BY count(*) DESC LIMIT 1	customers_and_invoices
SELECT count(*) ,  account_id FROM Financial_transactions	customers_and_invoices
SELECT count(*) ,  customer_id FROM Accounts GROUP BY customer_id	customers_and_invoices
SELECT T2.customer_last_name ,  T1.customer_id ,  T2.phone_number FROM Orders AS T1 JOIN Customers AS T2 ON T1.customer_id  =  T2.customer_id GROUP BY T1.customer_id ORDER BY count(*) DESC LIMIT 1	customers_and_invoices
SELECT T2.customer_first_name ,  T2.customer_last_name FROM Accounts AS T1 JOIN Customers AS T2 ON T1.customer_id  =  T2.customer_id WHERE T1.account_name  =  "900"	customers_and_invoices
SELECT T1.account_id ,  T1.date_account_opened ,  T1.account_name ,  T1.other_account_details FROM Accounts AS T1 JOIN Customers AS T2 ON T1.customer_id  =  T2.customer_id WHERE T2.customer_first_name  =  'Meaghan'	customers_and_invoices
SELECT T2.customer_first_name ,  T1.customer_id FROM Accounts AS T1 JOIN Customers AS T2 ON T1.customer_id  =  T2.customer_id GROUP BY T1.customer_id HAVING count(*)  >=  2	customers_and_invoices
SELECT order_id ,  count(*) FROM Order_items GROUP BY order_id	customers_and_invoices
SELECT DISTINCT T1.customer_first_name ,  T1.customer_last_name ,  T1.phone_number FROM Customers AS T1 JOIN Accounts AS T2 ON T1.customer_id  =  T2.customer_id	customers_and_invoices
SELECT T1.account_id ,  T2.account_name FROM Financial_transactions AS T1 JOIN Accounts AS T2 ON T1.account_id  =  T2.account_id GROUP BY T1.account_id HAVING count(*)  >=  4	customers_and_invoices
SELECT invoice_number ,  count(*) FROM Financial_transactions GROUP BY invoice_number	customers_and_invoices
SELECT order_id ,  sum(product_quantity) FROM Order_items GROUP BY order_id	customers_and_invoices
SELECT transaction_id FROM Financial_transactions WHERE transaction_amount  >  (SELECT avg(transaction_amount) FROM Financial_transactions)	customers_and_invoices
SELECT T2.order_id ,  T2.order_details FROM Invoices AS T1 JOIN Orders AS T2 ON T1.order_id  =  T2.order_id GROUP BY T2.order_id HAVING count(*)  >  2	customers_and_invoices
SELECT count(*) FROM Customers WHERE customer_id NOT IN (SELECT customer_id FROM Accounts)	customers_and_invoices
SELECT order_id ,  count(*) FROM Invoices GROUP BY order_id	customers_and_invoices
SELECT DISTINCT product_size FROM Products	customers_and_invoices
SELECT avg(transaction_amount) ,  min(transaction_amount) ,  max(transaction_amount) ,   sum(transaction_amount) FROM Financial_transactions	customers_and_invoices
SELECT account_id ,  date_account_opened ,  account_name ,  other_account_details FROM Accounts	customers_and_invoices
SELECT customer_id FROM Customers EXCEPT SELECT customer_id FROM Accounts	customers_and_invoices
SELECT count(*) ,  customer_id FROM Accounts GROUP BY customer_id	customers_and_invoices
SELECT T1.invoice_date ,  T1.order_id ,  T2.order_details FROM Invoices AS T1 JOIN Orders AS T2 ON T1.order_id  =  T2.order_id	customers_and_invoices
SELECT count(DISTINCT customer_id) FROM Accounts	customers_and_invoices
SELECT T1.customer_id ,  T2.customer_first_name ,  T2.customer_last_name FROM Accounts AS T1 JOIN Customers AS T2 ON T1.customer_id  =  T2.customer_id GROUP BY T1.customer_id ORDER BY count(*) DESC LIMIT 1	customers_and_invoices
SELECT count(*) FROM Accounts	customers_and_invoices
SELECT product_name FROM Products EXCEPT SELECT T1.product_name FROM Products AS T1 JOIN Order_items AS T2 ON T1.product_id  =  T2.product_id	customers_and_invoices
SELECT T1.customer_id ,  T2.customer_first_name ,  T2.customer_last_name FROM Accounts AS T1 JOIN Customers AS T2 ON T1.customer_id  =  T2.customer_id GROUP BY T1.customer_id ORDER BY count(*) DESC LIMIT 1	customers_and_invoices
SELECT count(*) FROM Financial_transactions	customers_and_invoices
SELECT count(*) ,  account_id FROM Financial_transactions	customers_and_invoices
SELECT count(DISTINCT customer_id) FROM Accounts	customers_and_invoices
SELECT account_id FROM Financial_transactions GROUP BY account_id ORDER BY count(*) DESC LIMIT 1	customers_and_invoices
SELECT gender ,  count(*) FROM Customers GROUP BY gender	customers_and_invoices
SELECT count(*) FROM Financial_transactions AS T1 JOIN Accounts AS T2 ON T1.account_id  =  T2.account_id WHERE T2.account_name  =  "337"	customers_and_invoices
SELECT invoice_number ,  count(*) FROM Financial_transactions GROUP BY invoice_number	customers_and_invoices
SELECT T2.customer_first_name ,  T1.customer_id FROM Accounts AS T1 JOIN Customers AS T2 ON T1.customer_id  =  T2.customer_id GROUP BY T1.customer_id HAVING count(*)  >=  2	customers_and_invoices
SELECT T2.invoice_number ,  T2.invoice_date FROM Financial_transactions AS T1 JOIN Invoices AS T2 ON T1.invoice_number  =  T2.invoice_number GROUP BY T1.invoice_number ORDER BY count(*) DESC LIMIT 1	customers_and_invoices
SELECT T2.account_name ,  T1.account_id ,  count(*) FROM Financial_transactions AS T1 JOIN Accounts AS T2 ON T1.account_id  =  T2.account_id GROUP BY T1.account_id	customers_and_invoices
SELECT T1.customer_id ,  T2.customer_first_name ,  T2.customer_last_name ,  count(*) FROM Accounts AS T1 JOIN Customers AS T2 ON T1.customer_id  =  T2.customer_id GROUP BY T1.customer_id	customers_and_invoices
SELECT account_id ,  date_account_opened ,  account_name ,  other_account_details FROM Accounts	customers_and_invoices
SELECT product_name FROM Products EXCEPT SELECT T1.product_name FROM Products AS T1 JOIN Order_items AS T2 ON T1.product_id  =  T2.product_id	customers_and_invoices
