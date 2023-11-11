create or replace FUNCTION ADDSTUDENT(
p_sname VARCHAR(50)
) returns INTEGER AS $$
declare
v_st_id INTEGER;
BEGIN
insert into student (p_sname)
values (p_sname)
returning st_id into v_st_id;
RETURN v_st_id;
END;
$$ LANGUAGE plpgsql;

create or replace FUNCTION ADDSUBJECT(
p_sname VARCHAR(50)
) returns INTEGER AS $$
declare
v_st_id INTEGER;
BEGIN
insert into subject (p_sname)
values (p_sname)
returning st_id into v_st_id;
RETURN v_st_id;
END;
$$ LANGUAGE plpgsql;

create or replace FUNCTION ADDACHIEVEMENT(
p_sname VARCHAR(50),
p_subname VARCHAR(50)
) returns VOID AS $$
declare
v_st_id INTEGER;
v_sb_id INTEGER;
begin
	select st_id into v_st_id from student where st_name = p_sname;

	select sb_id into v_sb_id from subject where sb_name = p_subname;

	insert into acheivement (sb_id, st_id)
	values (v_sb_id, v_st_id);
END;
$$ LANGUAGE plpgsql;