-- What are the top 5 brands by receipts scanned for most recent month?
with cte as (
    select 
        b.name, 
        dense_rank() over(order by sum(ro.quantitypurchased) desc) as ranked
    from external_data.vela_receipt_orders_rp ro 
        left join external_data.vela_receipts_rp r on cast(ro.receipt_id as varchar) = r.receiptid
        left join external_data.vela_brands_rp b on b.barcode = ro.barcode 
    where b.topbrand = True
    and date(r.receipt_scanneddate) = date_trunc( 'month', date(current_date))
    group by b.name
)
select name
from cte
where ranked <=5

-- How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?
with cte as (
    select 
        b.name, 
        dense_rank() over(partition by date_trunc('month', date(receipt_scanneddate)) order by sum(ro.quantitypurchased) desc) as ranked
    from external_data.vela_receipt_orders_rp ro 
        left join external_data.vela_receipts_rp r on cast(ro.receipt_id as varchar) = r.receiptid
        left join external_data.vela_brands_rp b on b.barcode = ro.barcode 
    where b.topbrand = True
        and date(r.receipt_scanneddate) between date_add('month', -1, date_trunc( 'month', date(current_date))) and date_trunc( 'month', date('1970-02-01'))
    group by b.name
)
select 
    name
from cte
where ranked <=5


-- When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
select
    case when
        (
        avg(case when rewardsReceiptStatus = 'Accepted' then totalspent end) -
        avg(case when rewardsReceiptStatus = 'Rejected' then totalspent end)
        ) > 0 
        then 'Average spend for Accepted status is greater' 
        
        when
        (
        avg(case when rewardsReceiptStatus = 'Accepted' then totalspent end) -
        avg(case when rewardsReceiptStatus = 'Rejected' then totalspent end)
        ) = 0 
        then 'Both Accepted and Rejected status transactions have same average spend' 
        
        ELSE 'Average spend for Rejected status is greater' end as result
from external_data.vela_receipts_rp


-- When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
select 
    case when
            (
            sum(case when rewardsReceiptStatus = 'Accepted' then purchaseditemcount end) -
            sum(case when rewardsReceiptStatus = 'Rejected' then purchaseditemcount end)
            ) > 0 
            then 'Total items purchased for Accepted status is greater' 
            
            when
            (
            sum(case when rewardsReceiptStatus = 'Accepted' then purchaseditemcount end) -
            sum(case when rewardsReceiptStatus = 'Rejected' then purchaseditemcount end)
            ) = 0 
            then 'Both Accepted and Rejected status transactions have same number of total number of items purchased' 
            
            ELSE 'Total items purchased for Rejected status is greater' end as result
from external_data.vela_receipts_rp 

-- Which brand has the most spend among users who were created within the past 6 months?

with cte as (
SELECT 
    b.name, 
    dense_rank() over(order by sum(totalspent) desc) as ranked
    
FROM external_data.vela_receipt_orders_rp ro 
    left join external_data.vela_receipts_rp r on cast(ro.receipt_id as varchar) = r.receiptid
    left join external_data.vela_brands_rp b on b.barcode = ro.barcode 

where date(receipt_createdate) between DATE_ADD('month',-6, DATE_TRUNC('month', CURRENT_DATE)) and DATE_TRUNC('month', CURRENT_DATE)
group by b.name
)
select 
    name 
from cte 
where ranked=1

-- Which brand has the most transactions among users who were created within the past 6 months?

with cte as (
SELECT 
    b.name, 
    dense_rank() over(order by count(cast(receipt_id as varchar)) desc) as ranked
    
FROM external_data.vela_receipt_orders_rp ro 
    left join external_data.vela_receipts_rp r on cast(ro.receipt_id as varchar) = r.receiptid
    left join external_data.vela_brands_rp b on b.barcode = ro.barcode 

where date(receipt_createdate) between DATE_ADD('month',-6, DATE_TRUNC('month', CURRENT_DATE)) and DATE_TRUNC('month', CURRENT_DATE)
group by b.name
)
select 
    name 
from cte 
where ranked=1





