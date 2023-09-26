
/*
 * List suppliers in the supplier table who do not supply any items.
 * */
select supplier_name from b2_supplier
except
-- fill in the gap.
(SELECT supplier_name FROM b2_supplier JOIN b2_stock USING (supplier_id));

/*
 * Using SET functions, get the customer_name for customers 
 * who bought a 'Phillips screwdriver' or  a 'Box of 6" screws'. 
 */

SELECT customer_name
from b2_customer 
join b2_corder using (customer_id)
  join b2_corderline USING (corderno)
  join b2_stock using (stock_code)
  WHERE stock_description = 'Phillips screwdriver'
  union
 SELECT customer_name
from b2_customer 
join b2_corder using (customer_id)
  join b2_corderline USING (corderno)
  join b2_stock using (stock_code)
  WHERE stock_description = 'Box of 6" screws';
 
/*
 * Using SET functions, get the customer_name for customers 
 * who bought a 'Phillips screwdriver' or  a 'Box of 6" screws'. 
 */
SELECT customer_name
from b2_customer 
join b2_corder using (customer_id)
  join b2_corderline USING (corderno)
  join b2_stock using (stock_code)
  WHERE stock_description = 'Phillips screwdriver'
  
  intersect
 
 SELECT customer_name
from b2_customer 
join b2_corder using (customer_id)
  join b2_corderline USING (corderno)
  join b2_stock using (stock_code)
  WHERE stock_description = 'Box of 6" screws';
 