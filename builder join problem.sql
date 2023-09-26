/*1.  List names of suppliers who supply no stock items */
select supplier_name from b2_supplier 
-- put join in here
b2_stock 
-- put join attribute / condition in here
where stock_code is null;

/* 2.  Get the name of any customer who bought the item with stock description 'Phillips screwdriver'.*/
select customer_name from b2_customer 
-- put join path in here
b2_stock 
-- put join attribute / condition in here
where stock_description = 'Phillips screwdriver';

/* 3. Get names of all staff members and the corderno for any orders they issued. */
select staff_name, corderno from b2_staff 
-- put join in here
b2_corder 
-- put join attribute / condition in here

/* 4. List the supplier_id and  supplier_name  for all supplier orders that were not delivered.*/
select supplier_id, supplier_name from b2_supplier  
-- put join path in here
join
b2_sorder using (supplier_id) 
-- put join attribute and / or final condition in here
where delivereddate is null;