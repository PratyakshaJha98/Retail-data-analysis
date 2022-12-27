CREATE DATABASE Retail_analysis
select * from dbo.Customer
select * from dbo.prod_cat_info
select * from dbo.Transactions

--------------------------------DATA PREPARATION AND UNDERSTANDING----------------------------------------------------------
-- Q.1)

Select count (*) from dbo.customer
union all
Select count (*) from dbo.prod_cat_info
union all
Select count (*) from dbo.Transactions

-- Q.2)
  
Select count(transaction_id) as no_of_transaction from dbo.Transactions
where total_amt < 0

--Q.3)
 
 --Date formatting done while importing the data.

--Q.4) 
 
select DATEDIFF(day, min(tran_date),max(tran_date)) as _Day,
DATEDIFF(Month,min(tran_date),max(tran_date)) as _Month,
datediff(year,min(tran_date),max(tran_date)) as _Year
from dbo.Transactions

--Q.5)
     
Select prod_cat from prod_cat_info
where prod_subcat = 'DIY'

----------------------Data Analysis-------------------------------------------------
--Q.1)

select top 1 store_type, count(transaction_id) as No_of_transaction from dbo.transactions
group by store_type
order by count(transaction_id) desc
	  
--Q.2)
	 
select gender, count(gender) as count_ from dbo.customer
where gender in ('M' ,'F')
group by Gender

--Q.3)

Select top 1 city_code, count(customer_id) as Tot_customer from dbo.Customer
group by city_code
order by Tot_customer desc

--Q.4)

Select prod_cat, count(prod_subcat) as No_of_subcategory from dbo.prod_cat_info
where prod_cat = 'books'
group by prod_cat

--Q.5)

Select max(Qty) as Max_Qty_of_product from dbo.Transactions
 
--Q.6)

select prod_cat, sum(total_amt) as Net_total_rev from dbo.Transactions as T1
inner join dbo.prod_cat_info as T2
on T1.prod_cat_code = T2.prod_cat_code and
T1.prod_subcat_code = T2.prod_sub_cat_code
where prod_cat in ('Electronics' , 'Books')
group by prod_cat

--Q.7)

Select cust_id, count(transaction_id) as no_of_transactions from dbo.Transactions
where total_amt > 0
group by cust_id
having count(transaction_id) > 10

--Q.8)

Select prod_cat, T2.store_type, sum(T2.total_amt) as Combind_revenue from dbo.prod_cat_info as T1
inner join dbo.Transactions T2
on T1.prod_cat_code =T2.prod_cat_code 
and T1.prod_sub_cat_code = T2.prod_subcat_code
where prod_cat in ('Electronics' , 'clothing')
and Store_type = 'Flagship store'
group by prod_cat, T2.Store_type

--Q.9)

Select prod_subcat, sum(T2.total_amt) as total_revenue from dbo.prod_cat_info as T1
left join dbo.Transactions as T2
on T1.prod_cat_code = T2.prod_cat_code
and T1.prod_sub_cat_code = T2.prod_subcat_code
left join Customer as T3
on T3.customer_Id = T2.cust_id
where Gender = 'M' and prod_cat = 'Electronics'
group by prod_subcat

--Q.10)
Select top 5 PROD_SUBCAT,
(Sum(case when total_amt > 0  Then total_amt  end)/SUM(total_amt))*100 as Sales_percentage,
abs (Sum( Case when total_amt < 0 THEN total_amt  end)/Sum(total_amt))*100 as  Return_percentage
From prod_cat_info inner join Transactions 
on prod_cat_info.prod_sub_cat_code =Transactions.prod_subcat_code
and prod_cat_info.prod_cat_code=Transactions.prod_cat_code
group by prod_subcat
order by Sales_percentage desc

--Q.11)

Select sum(total_amt) as total_sales from dbo.Customer as T1 inner join dbo.Transactions as T2
on T1.customer_Id = T2.cust_id
where DOB between DATEADD(year, -35,(select max(tran_date) from dbo.Transactions)) and DATEADD(year, -25,(select max(tran_date) from dbo.Transactions)) and
tran_date >= (select dateadd(day, -30, max(tran_date)) from dbo.Transactions)

--Q.12)

select prod_cat, sum(total_amt) as total_sum from dbo.prod_cat_info as T1
inner join dbo.Transactions as T2 on T1.prod_cat_code = T2.prod_cat_code and
T1.prod_sub_cat_code = T2.prod_subcat_code
where total_amt < 0 and tran_date between DATEADD(month, -3, (select max(tran_date) from dbo.transactions))
and (select max(tran_date) from dbo.transactions)
group by prod_cat
order by total_sum desc


--Q.13)

Select top 1 store_type, count(qty) as product_qty, sum(total_amt) as total_sales from dbo.Transactions
group by Store_type
order by product_qty desc

--Q.14) 

Select prod_cat, avg(total_amt) as average_Revenue
from dbo.Transactions as T1
inner join dbo.prod_cat_info as T2
on T1.prod_cat_code = T2.prod_cat_code
and T1.prod_subcat_code = T2.prod_sub_cat_code
group by prod_cat
having avg(total_amt) > (select AVG(total_amt) from dbo.Transactions)

--Q.15)

select prod_cat, prod_subcat, avg(total_amt) as Avg_revenue, sum(total_amt) as total_revenue from dbo.Transactions as T1 inner join dbo.prod_cat_info as T2
on T1.prod_cat_code = T2.prod_cat_code and T1.prod_subcat_code = T2.prod_sub_cat_code
where prod_cat in
(select top 5 prod_cat from dbo.Transactions inner join dbo.prod_cat_info on T1.prod_cat_code = T2.prod_cat_code 
group by prod_cat
order by sum(qty) desc)
group by prod_cat, prod_subcat

