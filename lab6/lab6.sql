# 1
create database l6_p1;
use l6_p1;

create table STUDENT_MARKS
	(STUDENT_ID int, 
	NAME varchar(100), 
	SUB1 int, 
	SUB2 int, 
	SUB3 int, 
	SUB4 int, 
	SUB5 int, 
	TOTAL int, 
	PER_MARKS decimal(6,3), 
	GRADE varchar(50), 
	primary key(STUDENT_ID));

delimiter $$

create trigger UPDATE_TRIGGER
	before update
		on STUDENT_MARKS for each row
		begin
			set new.TOTAL = new.SUB1+new.SUB2+new.SUB3+new.SUB4+new.SUB5;
			set new.PER_MARKS = new.TOTAL/5;
			if new.PER_MARKS >= 90 then
				set new.GRADE = 'Excellent';
			elseif new.PER_MARKS >= 75 then
				set new.GRADE = 'Very Good';
			elseif new.PER_MARKS >= 60 then
				set new.GRADE = 'Good';
			elseif new.PER_MARKS >= 40 then
				set new.GRADE = 'Average';
			else 
				set new.GRADE = 'Not Promoted';
			end if;
		end $$

delimiter ;

insert into STUDENT_MARKS 
	values(1,'Steven King',0,0,0,0,0,0,0,'');
insert into STUDENT_MARKS 
	values(2,'Neena Kocchar',0,0,0,0,0,0,0,'');
insert into STUDENT_MARKS 
	values(3,'Lex De Haan',0,0,0,0,0,0,0,'');
insert into STUDENT_MARKS 
	values(4,'Alexander Hunold',0,0,0,0,0,0,0,'');

update STUDENT_MARKS set 
	SUB1=54, 
	SUB2=69, 
	SUB3=89, 
	SUB4=87, 
	SUB5=59 
	where STUDENT_ID=1;

# 2
create database l6_p2;
use l6_p2

CREATE TABLE blog (
	id int,title varchar(100),
	content varchar(100),
	deleted int,
	PRIMARY KEY (id)
	);

CREATE TABLE audit( blog_id int,
	changetype enum('NEW','EDIT','DELETE') NOT NULL,
	changetime timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE
	RENT_TIMESTAMP,
	foreign key(blog_id) references blog(id)
	) ;

delimiter $$

create trigger insert_blog 
	after insert
		on blog for each row 
		begin 
			if new.deleted=1 then 
				insert into audit values(new.id,'DELETE',curtime()); 
			else 
				insert into audit values(new.id,'NEW',curtime()); 
			end if; 
		end$$

create trigger update_blog
	after update 
		on blog for each row 
		begin 
			if new.deleted=1 then 
				insert into audit values(old.id,'DELETE',curtime()); 
			elseif new.deleted<>1 then
				insert into audit values(old.id,'EDIT',curtime()); 
			end if; 
		end$$

delimiter ;

# 3
create database l6_p3;
use l6_p3

create table PATIENTS
	(id int,
	name varchar(20),
	rn INT
	);

create table ROOM 
	(patientID int ,
	room_no int,
	room_status enum('EMPTY', 'OCCUPIED') not null
	);

create table MEDICINE
	(patientID int,
	name varchar(30)
	);

create table BILL
	(patientID int,
	amount double
	);

insert into PATIENTS values(101, 'a',1);
insert into PATIENTS values(102, 'b',2);

insert into ROOM values (101, 1, 'OCCUPIED');
insert into ROOM values (102, 2, 'OCCUPIED');

insert into MEDICINE values (101, 'medA');
insert into MEDICINE values (102, 'medB');

insert into BILL values (101, 200);
insert into BILL values (102, 200);

delimiter $$
CREATE TRIGGER delete_trigger
	BEFORE DELETE ON PATIENTS
	FOR EACH ROW
		BEGIN
			DELETE FROM MEDICINE WHERE patientID=OLD.id;
			DELETE FROM BILL WHERE patientID=OLD.id;
			UPDATE ROOM SET room_status='EMPTY' WHERE patientID=OLD.id;
			UPDATE ROOM SET patientID=NULL WHERE room_no=OLD.rn;
		END $$

DELIMITER ;

delete from PATIENTS where id=101;