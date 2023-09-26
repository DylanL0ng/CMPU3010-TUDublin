commit;
drop table acheivement;
drop table subject;
drop table student;
create table student (st_id serial primary key,
st_name varchar(50) not null);

create table subject (sb_id serial primary key,
sb_name varchar(50) not null,
sb_syllabus varchar(255));

create table acheivement(
sb_id integer not null references subject,
st_id integer not null references student,
primary key (sb_id, st_id));
begin transaction;
insert into student(st_name) values 
('John'),
('Mary'),
('Maria'),
('Mohammed'),
('Lisa'),
('Henri');
insert into subject(sb_name, sb_syllabus) values
('Maths','Hard Sums'),
('English','Lots of reading'),
('Geography','Places to go'),
('Sport','Running and football');
select * from student;
select * from subject;
insert into acheivement values 
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(3, 1),
(3, 2),
(3, 3),
(3, 4),
(4, 1),
(4, 2),
(4, 3),
(4, 4),
(1, 5),
(3, 5),
(4, 5),
(1, 6),
(2, 6),
(4, 6);
commit;
select * from student join acheivement using (st_id) join subject using (sb_id);
select st_name from student a where not exists (
select * from subject b where not exists (
select * from acheivement x where x.st_id = a.st_id and x.sb_id = b.sb_id));