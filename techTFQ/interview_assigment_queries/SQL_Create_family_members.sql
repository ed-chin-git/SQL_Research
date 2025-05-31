/** https://techtfq.com/video/real-sql-interview-query-complex-sql-interview-query-and-solution 
    https://youtu.be/i3xK7Nc414Q
**/

drop table if exists family_members CASCADE;
create table family_members
(
	person_id		varchar(20),
	relative_id1	varchar(20),
	relative_id2	varchar(20)
);

insert into family_members values('ATR-1', null, null);
insert into family_members values('ATR-2', 'ATR-1', null);
insert into family_members values('ATR-3', 'ATR-2', null);
insert into family_members values('ATR-4', 'ATR-3', null);
insert into family_members values('ATR-5', 'ATR-4', null);

insert into family_members values('BTR-1', null, null);
insert into family_members values('BTR-2', null, 'BTR-1');
insert into family_members values('BTR-3', null, 'BTR-2');
insert into family_members values('BTR-4', null, 'BTR-3');
insert into family_members values('BTR-5', null, 'BTR-4');

insert into family_members values('CTR-1', null, 'CTR-3');
insert into family_members values('CTR-2', 'CTR-1', null);
insert into family_members values('CTR-3', null, null);

insert into family_members values('DTR-1', 'DTR-3', 'ETR-2');
insert into family_members values('DTR-2', null, null);
insert into family_members values('DTR-3', null, null);

insert into family_members values('ETR-1', null, 'DTR-2');
insert into family_members values('ETR-2', null, null);

insert into family_members values('FTR-1', null, null);
insert into family_members values('FTR-2', null, null);
insert into family_members values('FTR-3', null, null);

insert into family_members values('GTR-1', 'GTR-1', null);
insert into family_members values('GTR-2', 'GTR-1', null);
insert into family_members values('GTR-3', 'GTR-1', null);

insert into family_members values('HTR-1', 'GTR-1', null);
insert into family_members values('HTR-2', 'GTR-1', null);
insert into family_members values('HTR-3', 'GTR-1', null);

insert into family_members values('ITR-1', null, null);
insert into family_members values('ITR-2', 'ITR-3', 'ITR-1');
insert into family_members values('ITR-3', null, null);

-- ___ check data  ____
select * from family_members;
