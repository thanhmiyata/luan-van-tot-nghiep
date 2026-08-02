select T1.invoice_number, T1.invoice_date from Invoices as T1 join Financial_Transactions as T2 on T1.invoice_number = T2.invoice_number group by T1.invoice_number, T1.invoice_date order by count(*) desc limit 1	customers_and_invoices
select account_id, count(transaction_id) from Financial_Transactions group by account_id	customers_and_invoices
select count(account_id), customer_id from Accounts group by customer_id	customers_and_invoices
select c.customer_last_name, c.customer_id, c.phone_number from Customers as c join Orders as o on c.customer_id = o.customer_id group by c.customer_id order by count(*) desc limit 1	customers_and_invoices
select T1.customer_first_name, T1.customer_last_name from Customers as T1 join Accounts as T2 on T1.customer_id = T2.customer_id where T2.account_name = "900"	customers_and_invoices
select T1.account_id, T1.account_name, T1.date_account_opened, T1.other_account_details from Accounts as T1 join Customers as T2 on T1.customer_id = T2.customer_id where T2.customer_first_name = "Meaghan"	customers_and_invoices
select c.customer_first_name, c.customer_id from Customers as c join Accounts as a on c.customer_id = a.customer_id group by c.customer_id having count(*) >= 2	customers_and_invoices
select order_id, count(order_item_id) from Order_Items group by order_id	customers_and_invoices
