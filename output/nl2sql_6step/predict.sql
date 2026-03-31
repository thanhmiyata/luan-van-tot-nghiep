select T1.invoice_number, T1.invoice_date from Invoices as T1 join Financial_Transactions as T2 on T1.invoice_number = T2.invoice_number group by T1.invoice_number, T1.invoice_date order by count(*) desc limit 1	customers_and_invoices
select account_id, count(transaction_id) from Financial_Transactions group by account_id	customers_and_invoices
select count(account_id), customer_id from Accounts group by customer_id	customers_and_invoices
select c.customer_last_name, c.customer_id, c.phone_number from Customers as c join Orders as o on c.customer_id = o.customer_id group by c.customer_id order by count(*) desc limit 1	customers_and_invoices
select T1.customer_first_name, T1.customer_last_name from Customers as T1 join Accounts as T2 on T1.customer_id = T2.customer_id where T2.account_name = "900"	customers_and_invoices
select T1.account_id, T1.account_name, T1.date_account_opened, T1.other_account_details from Accounts as T1 join Customers as T2 on T1.customer_id = T2.customer_id where T2.customer_first_name = "Meaghan"	customers_and_invoices
select c.customer_first_name, c.customer_id from Customers as c join Accounts as a on c.customer_id = a.customer_id group by c.customer_id having count(*) >= 2	customers_and_invoices
select order_id, count(order_item_id) from Order_Items group by order_id	customers_and_invoices
select distinct T1.customer_first_name, T1.customer_last_name, T1.phone_number from Customers as T1 join Accounts as T2 on T1.customer_id = T2.customer_id	customers_and_invoices
select Accounts.account_id, Accounts.account_name from Accounts inner join Financial_Transactions on Accounts.account_id = Financial_Transactions.account_id group by Accounts.account_id, Accounts.account_name having count(*) >= 4	customers_and_invoices
select invoice_number, count(*) from Financial_Transactions group by invoice_number	customers_and_invoices
select T1.order_id, sum(T2.product_quantity) from Orders as T1 join Order_Items as T2 on T1.order_id = T2.order_id group by T1.order_id	customers_and_invoices
select transaction_id from Financial_Transactions where transaction_amount > (select avg(transaction_amount) from Financial_Transactions)	customers_and_invoices
select T1.order_id, T1.order_details from Orders as T1 inner join Invoices as T2 on T1.order_id = T2.order_id group by T1.order_id having count(*) >= 2	customers_and_invoices
select count(Customers.customer_id) from Customers left join Accounts on Customers.customer_id = Accounts.customer_id where Accounts.customer_id is null	customers_and_invoices
select order_id, count(invoice_number) from Invoices group by order_id	customers_and_invoices
select product_size from Products	customers_and_invoices
select avg(transaction_amount), min(transaction_amount), max(transaction_amount), sum(transaction_amount) from Financial_Transactions	customers_and_invoices
select account_id, date_account_opened, account_name, other_account_details from Accounts	customers_and_invoices
select Customers.customer_id from Customers left join Accounts on Customers.customer_id = Accounts.customer_id where Accounts.customer_id is null	customers_and_invoices
select customer_id, count(account_id) from Accounts group by customer_id	customers_and_invoices
select Invoices.invoice_date, Invoices.order_id, Orders.order_details from Invoices inner join Orders on Invoices.order_id = Orders.order_id	customers_and_invoices
select count(distinct customer_id) from Accounts	customers_and_invoices
select Customers.customer_id, Customers.customer_first_name, Customers.customer_last_name from Customers inner join Accounts on Customers.customer_id = Accounts.customer_id group by Customers.customer_id, Customers.customer_first_name, Customers.customer_last_name order by count(*) desc limit 1	customers_and_invoices
select count(*) from Accounts	customers_and_invoices
select T1.product_name from Products as T1 left join Order_Items as T2 on T1.product_id = T2.product_id where T2.product_id is null	customers_and_invoices
select C.customer_id, C.customer_first_name, C.customer_middle_initial, C.customer_last_name from Customers C join Accounts A on C.customer_id = A.customer_id group by C.customer_id, C.customer_first_name, C.customer_middle_initial, C.customer_last_name order by count(*) desc limit 1	customers_and_invoices
select count(*) from Financial_Transactions	customers_and_invoices
select count(transaction_id), account_id as "account id" from Financial_Transactions group by account_id	customers_and_invoices
select count(distinct customer_id) from Accounts	customers_and_invoices
select account_id from Financial_Transactions group by account_id order by count(*) desc limit 1	customers_and_invoices
select gender, count(customer_id) from Customers group by gender	customers_and_invoices
select count(*) from Accounts inner join Financial_Transactions on Accounts.account_id = Financial_Transactions.account_id where Accounts.account_name = "337"	customers_and_invoices
select invoice_number, count(transaction_id) from Financial_Transactions group by invoice_number	customers_and_invoices
select c.customer_first_name, c.customer_id from Customers c join Accounts a on c.customer_id = a.customer_id group by c.customer_id, c.customer_first_name having count(*) >= 2	customers_and_invoices
select T1.invoice_number, T1.invoice_date from Invoices as T1 join Financial_Transactions as T2 on T1.invoice_number = T2.invoice_number group by T1.invoice_number, T1.invoice_date order by count(*) desc limit 1	customers_and_invoices
select Accounts.account_name, Accounts.account_id, count(*) from Accounts join Financial_Transactions on Accounts.account_id = Financial_Transactions.account_id group by Accounts.account_name, Accounts.account_id	customers_and_invoices
select Customers.customer_first_name, Customers.customer_middle_initial, Customers.customer_last_name, Customers.customer_id, count(Accounts.account_id) from Customers left join Accounts on Customers.customer_id = Accounts.customer_id group by Customers.customer_id	customers_and_invoices
select account_id, date_account_opened, account_name, other_account_details from Accounts	customers_and_invoices
select T1.product_name from Products as T1 left join Order_Items as T2 on T1.product_id = T2.product_id where T2.product_id is null	customers_and_invoices
