-- This function checks if the part model exists in the
-- model_part table if it does it allows the entry to be
-- made, if it doesnt it will throw and exception
create or replace function validate_part_model()
returns trigger as $$
begin
	-- Checks if any model exists in table
    if (select count(*) from "Bike856BB".model_part m where m.parts_partid = new.parts_partid) = 0 then
        raise exception 'Invalid model part';
    else
        return new;
    end if;
end;
$$ language plpgsql;

-- Trigger to execute before insert or update
create trigger model_part_validation
before insert or update on repairpart
for each row execute function validate_part_model();