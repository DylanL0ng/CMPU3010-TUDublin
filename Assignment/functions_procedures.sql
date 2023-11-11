-- Function gets bikes awaiting repair given the status is 'R'
-- and returns the records
create or replace function get_bikes_awaiting_repair()
returns table (serialnumber "Bike856BB".bike.serialnumber%type, repairnumber "Bike856BB".bike.repairnumber%type, modelid "Bike856BB".bike.modelid%type, customerid "Bike856BB".bike.customerid%type) as $$
begin
    return query select b.serialnumber, b.repairnumber, b.modelid, b.customerid from "Bike856BB".bike b where b.status = 'R';
    
    if not found then
		raise exception 'No bikes are awaiting repairs!';
	end if;
end;
$$ language plpgsql;

-- Function gets bike given serial number is equal to the given
-- serial number and returns repair description
create or replace function get_bike_description(b_serial "Bike856BB".bike.serialnumber%type)
returns varchar as $$
declare 
    bike_description varchar;
begin
    select r.description into bike_description from "Bike856BB".repair r where r.serialnumber = b_serial;

    if not found then
        raise exception 'Bike repair not found!';
    end if;
   
    return bike_description;
end;
$$ language plpgsql;

-- Function creates a new record in the repair table logging the 
-- hours spent on repair and description it returns the repair_id
-- used to log new parts in a procedure
create or replace function log_repair(
    b_serial "Bike856BB".bike.serialnumber%TYPE, 
    r_description "Bike856BB".repair.description%type, 
    r_hours "Bike856BB".repair.hoursspent%type
)
returns "Bike856BB".repair.repairid%type
language plpgsql
as $$
declare 
    repair_id "Bike856BB".repair.repairid%type;
begin
    insert into "Bike856BB".repair(description, hoursspent, serialnumber) 
    values (r_description, r_hours, b_serial) 
    returning repairid into repair_id;
    
    return repair_id;
end;
$$;

-- This procedure logs each part used in a repair given the
-- repair id and part details such as quantity and part id
create or replace procedure record_part_repaired(r_quantity "Bike856BB".repairpart.quantity%type, r_repairid "Bike856BB".repair.repairid%type, r_partsid "Bike856BB".model_part.parts_partid%type)
language plpgsql
AS $$
BEGIN
	insert into "Bike856BB".repairpart (quantity, repair_repairid, parts_partid) values (r_quantity, r_repairid, r_partsid);
END;
$$;