drop table bike cascade;
drop table customer cascade;
drop table model  cascade;
drop table model_part  cascade;
drop table parts cascade;
drop table repair cascade;
drop table repairpart cascade;
drop table supplier cascade;


CREATE TABLE bike (
    serialnumber SERIAL PRIMARY KEY,
    status CHAR(1),
    repairnumber INTEGER,
    modelid INTEGER NOT NULL,
    customerid INTEGER NOT NULL
);

CREATE TABLE customer (
    customerid SERIAL PRIMARY KEY,
    name VARCHAR(40) NOT NULL,
    contactnumber VARCHAR(40) NOT NULL
);

CREATE TABLE model (
    modelid SERIAL PRIMARY KEY,
    modelname VARCHAR(40),
    supplier_supplierid INTEGER NOT NULL
);

CREATE TABLE model_part (
    modelpartname VARCHAR(40),
    modelid INTEGER NOT NULL,
    parts_partid INTEGER NOT NULL
);

CREATE TABLE parts (
    partid SERIAL PRIMARY KEY,
    partname VARCHAR(40)
);

CREATE TABLE repair (
    repairid SERIAL PRIMARY KEY,
    description VARCHAR(50),
    hoursspent INTEGER,
    serialnumber INTEGER NOT NULL
);

CREATE TABLE repairpart ( 
    quantity INTEGER,
    repair_repairid INTEGER NOT NULL,
    parts_partid INTEGER NOT NULL
);

CREATE TABLE supplier (
    supplierid SERIAL PRIMARY KEY,
    suppliername VARCHAR(40)
);

ALTER TABLE bike
    ADD CONSTRAINT bike_customer_fk FOREIGN KEY (customerid)
        REFERENCES customer (customerid);

ALTER TABLE bike
    ADD CONSTRAINT bike_model_fk FOREIGN KEY (modelid)
        REFERENCES model (modelid);

ALTER TABLE model_part
    ADD CONSTRAINT model_part_parts_fk FOREIGN KEY (parts_partid)
        REFERENCES parts (partid);

ALTER TABLE model
    ADD CONSTRAINT model_supplier_fk FOREIGN KEY (supplier_supplierid)
        REFERENCES supplier (supplierid);

ALTER TABLE model_part
    ADD CONSTRAINT part_model_fk FOREIGN KEY (modelid)
        REFERENCES model (modelid);

ALTER TABLE repair
    ADD CONSTRAINT repair_bike_fk FOREIGN KEY (serialnumber)
        REFERENCES bike (serialnumber);

ALTER TABLE repairpart
    ADD CONSTRAINT repairpart_parts_fk FOREIGN KEY (parts_partid)
        REFERENCES parts (partid);

ALTER TABLE repairpart
    ADD CONSTRAINT repairpart_repair_fk FOREIGN KEY (repair_repairid)
        REFERENCES repair (repairid);

       
-- Inserts 
-- Sample data for the supplier table
insert into supplier (supplierid, suppliername)
values
    (201, 'Bike Parts Supplier A'),
    (202, 'Bike Parts Supplier B'),
    (203, 'Bike Parts Supplier C');

-- Sample data for the parts table
insert into parts (partid, partname)
values
    (301, 'Spokes'),
    (302, 'Aluminium Frame'),
    (303, 'Drop Handlebar'),
    (304, 'Carbon Seat');

-- Sample data for the model table
insert into model (modelid, modelname, supplier_supplierid)
values
    (1, 'Mountain Bike', 201),
    (2, 'Road Bike', 202),
    (3, 'Hybrid Bike', 203);

-- Sample data for the customer table
insert into customer (customerid, name, contactnumber)
values
    (101, 'Brian Johann', '555-123-4567'),
    (102, 'Jenny Smith', '555-987-6543'),
    (103, 'Bob Kenny', '555-555-5555'),
    (104, 'Anna Brown', '555-111-2222');

-- Sample data for the bike table
insert into bike (serialnumber, status, repairnumber, modelid, customerid)
values
    (1, 'R', 1001, 1, 101),
    (2, 'C', 1002, 2, 102),
    (3, 'F', 1003, 1, 103),
    (4, 'R', 1004, 3, 104);

-- Sample data for the model_part table (Compound PK)
insert into model_part (modelpartname, modelid, parts_partid)
values
    ('Wheel', 1, 301),
    ('Frame', 2, 302),
    ('Handlebar', 3, 303),
    ('Seat', 1, 304);

-- Sample data for the repair table
insert into repair (repairid, description, hoursspent, serialnumber) 
values
    (1001, 'Replacing spokes', 3, 1),
    (1002, 'Tune-up and maintenance', 2, 2),
    (1003, 'Assembly and safety check', 1, 3),
    (1004, 'Replacing and adjusting seat', 0.5, 4);

-- Sample data for the repairpart table (Compound PK)
insert into repairpart (quantity, repair_repairid, parts_partid)
values
    (32, 1001, 301),
    (1, 1002, 303),
    (1, 1003, 302),
    (2, 1004, 304);      
       
-- Grants
      
-- Receptionist Role (Martin Januska)
grant usage on schema "Bike856BB" to "C21327411";
grant execute on function "Bike856BB".add_customer to "C21327411";
grant select, insert, update on table "Bike856BB".customer to "C21327411";
grant select on table "Bike856BB".bike to "C21327411";
grant select on table "Bike856BB".repair to "C21327411";
grant usage, select on sequence "Bike856BB"."customer_customerid_seq" to "C21327411";

-- Mechanic Role (Dylan Hussain)
grant usage on schema "Bike856BB" to "C21331063";
grant execute on function "Bike856BB".get_bikes_awaiting_repair to "C21331063";
grant execute on function "Bike856BB".get_bike_description to "C21331063";
grant execute on function "Bike856BB".log_repair to "C21331063";
grant execute on procedure "Bike856BB".record_part_repaired to "C21331063";
grant select, insert on table "Bike856BB".bike to "C21331063";
grant select, insert on table "Bike856BB".repair to "C21331063";
grant select, insert on table "Bike856BB".repairpart to "C21331063";
grant select on table "Bike856BB".model_part to "C21331063";
grant usage, select on sequence "Bike856BB"."repair_repairid_seq" to "C21331063";









       
       