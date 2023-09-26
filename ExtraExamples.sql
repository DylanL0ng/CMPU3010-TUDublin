-- Sub-query example

SELECT supplier_name
FROM b2_supplier
WHERE supplier_id NOT IN
(SELECT supplier_id from b2_STOCK);

Select staff_no, reports_to from b2_staff;
select e.staff_no, e.staff_name, b.staff_no, b.staff_name
from b2_staff e left join b2_staff b on e.reports_to = b.staff_no;

select staff_no, reports_to 
from b2_staff
where reports_to is null;

select staff_no from b2_staff where reports_to not in (51,52);



create or replace view custbought as
Select customer_name, stock_description
From b2_customer
Join b2_corder using (customer_id)
Join b2_corderline using (corderno)
Join b2_stock using (stock_code);

Select customer_name from custbought where stock_description = 'Phillips screwdriver';

