/* Display the customer order number (corderno), stock_code and cost (unit_price * quantityrequired) 
 * of every order line (corderline) on every customer order (corder).*/

select corderno, stock_code, (unit_price * quantityrequired) "Line Cost"
-- calculate cost here
from b2_corder join b2_corderline using (corderno)
join b2_stock using (stock_code)
--add any clauses required here

;

/* Display the customer order number (corderno) and total cost (unit_price * quantityrequired) 
 * of  every customer order (corder).*/
select corderno, sum(unit_price * quantityrequired) "Order Cost"
-- calculate total cost here
from b2_corder join b2_corderline using (corderno)
join b2_stock using (stock_code)
group by corderno
--add any clauses required here
;

/* Display the customer order number (corderno) and total cost (unit_price * quantityrequired) 
 * of  every customer order that costs more than €2,000.*/
select corderno, sum(unit_price * quantityrequired) "Order Cost"
-- calculate total cost here
from b2_corder join b2_corderline using (corderno)
join b2_stock using (stock_code)
--where "Order Cost" > 2000
group by corderno
--add any clauses required here
;