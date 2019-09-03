create database DATABASE2;
use DATABASE2;
CREATE TABLE EMPLOYEE
( Fname VARCHAR(10) NOT NULL,
  Minit CHAR,
  Lname VARCHAR(20) NOT NULL,
  Ssn CHAR(9) NOT NULL,
  Bdate DATE,
  Address VARCHAR(30),
  Sex CHAR(1),
  Salary DECIMAL(5),
  Super_ssn CHAR(9),
  Dno INT NOT NULL,
PRIMARY KEY(Ssn));

CREATE TABLE DEPARTMENT
( Dname VARCHAR(15) NOT NULL,
  Dnumber INT NOT NULL,
  Mgr_ssn CHAR(9) NOT NULL,
  Mgr_start_date DATE,
PRIMARY KEY (Dnumber),
UNIQUE (Dname),
FOREIGN KEY (Mgr_ssn) REFERENCES EMPLOYEE(Ssn) );

CREATE TABLE DEPT_LOCATIONS
( Dnumber INT NOT NULL,
  Dlocation VARCHAR(15) NOT NULL,
PRIMARY KEY (Dnumber, Dlocation),
FOREIGN KEY (Dnumber) REFERENCES DEPARTMENT(Dnumber) );

CREATE TABLE PROJECT
( Pname VARCHAR(15) NOT NULL,
  Pnumber INT NOT NULL,
  Plocation VARCHAR(15),
  Dnum INT NOT NULL,
PRIMARY KEY (Pnumber),
UNIQUE (Pname),
FOREIGN KEY (Dnum) REFERENCES DEPARTMENT(Dnumber) );

CREATE TABLE WORKS_ON
( Essn CHAR(9) NOT NULL,
  Pno INT NOT NULL,
  Hours DECIMAL(3,1) NOT NULL,
PRIMARY KEY (Essn, Pno),
FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn),
FOREIGN KEY (Pno) REFERENCES PROJECT(Pnumber) );

CREATE TABLE DEPENDENT
( Essn CHAR(9) NOT NULL,
  Dependent_name VARCHAR(15) NOT NULL,
  Sex CHAR,
  Bdate DATE,
  Relationship VARCHAR(8),
PRIMARY KEY (Essn, Dependent_name),
FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn) );

INSERT INTO EMPLOYEE
VALUES      ('John','B','Smith',123456789,'1965-01-09','731 Fondren, Houston TX','M',30000,333445555,5),
            ('Franklin','T','Wong',333445555,'1965-12-08','638 Voss, Houston TX','M',40000,888665555,5),
            ('Alicia','J','Zelaya',999887777,'1968-01-19','3321 Castle, Spring TX','F',25000,987654321,4),
            ('Jennifer','S','Wallace',987654321,'1941-06-20','291 Berry, Bellaire TX','F',43000,888665555,4),
            ('Ramesh','K','Narayan',666884444,'1962-09-15','975 Fire Oak, Humble TX','M',38000,333445555,5),
            ('Joyce','A','English',453453453,'1972-07-31','5631 Rice, Houston TX','F',25000,333445555,5),
            ('Ahmad','V','Jabbar',987987987,'1969-03-29','980 Dallas, Houston TX','M',25000,987654321,4),
            ('James','E','Borg',888665555,'1937-11-10','450 Stone, Houston TX','M',55000,null,1);

INSERT INTO DEPARTMENT
VALUES      ('Research',5,333445555,'1988-05-22'),
            ('Administration',4,987654321,'1995-01-01'),
            ('Headquarters',1,888665555,'1981-06-19');

INSERT INTO PROJECT
VALUES      ('ProductX',1,'Bellaire',5),
            ('ProductY',2,'Sugarland',5),
            ('ProductZ',3,'Houston',5),
            ('Computerization',10,'Stafford',4),
            ('Reorganization',20,'Houston',1),
            ('Newbenefits',30,'Stafford',4);

INSERT INTO WORKS_ON
VALUES     (123456789,1,32.5),
           (123456789,2,7.5),
           (666884444,3,40.0),
           (453453453,1,20.0),
           (453453453,2,20.0),
           (333445555,2,10.0),
           (333445555,3,10.0),
           (333445555,10,10.0),
           (333445555,20,10.0),
           (999887777,30,30.0),
           (999887777,10,10.0),
           (987987987,10,35.0),
           (987987987,30,5.0),
           (987654321,30,20.0),
           (987654321,20,15.0),
           (888665555,20,16.0);

INSERT INTO DEPENDENT
VALUES      (333445555,'Alice','F','1986-04-04','Daughter'),
            (333445555,'Theodore','M','1983-10-25','Son'),
            (333445555,'Joy','F','1958-05-03','Spouse'),
            (987654321,'Abner','M','1942-02-28','Spouse'),
            (123456789,'Michael','M','1988-01-04','Son'),
            (123456789,'Alice','F','1988-12-30','Daughter'),
            (123456789,'Elizabeth','F','1967-05-05','Spouse');

INSERT INTO DEPT_LOCATIONS
VALUES      (1,'Houston'),
            (4,'Stafford'),
            (5,'Bellaire'),
            (5,'Sugarland'),
            (5,'Houston');

ALTER TABLE DEPARTMENT
 ADD CONSTRAINT Dep_emp FOREIGN KEY (Mgr_ssn) REFERENCES EMPLOYEE(Ssn);

ALTER TABLE EMPLOYEE
 ADD CONSTRAINT Emp_emp FOREIGN KEY (Super_ssn) REFERENCES EMPLOYEE(Ssn);
ALTER TABLE EMPLOYEE
 ADD CONSTRAINT Emp_dno FOREIGN KEY  (Dno) REFERENCES DEPARTMENT(Dnumber);
ALTER TABLE EMPLOYEE
ADD CONSTRAINT Emp_super FOREIGN KEY (Super_ssn) REFERENCES EMPLOYEE(Ssn);

#1
select Fname,Bdate,Address from EMPLOYEE inner join DEPARTMENT on EMPLOYEE.Dno=DEPARTMENT.Dnumber where Dname='Administration';

#2
select MIN(Salary),MAX(Salary),Sum(Salary),AVG(Salary) from EMPLOYEE inner join DEPARTMENT on EMPLOYEE.Dno=DEPARTMENT.Dnumber where Dname='Research' group by Dno ;

#3
select count(distinct Ssn) from EMPLOYEE inner join DEPARTMENT on EMPLOYEE.Dno=DEPARTMENT.Dnumber where Dname='Administration';

#4
select Pnumber,Pname,count(Essn) from PROJECT inner join WORKS_ON on WORKS_ON.Pno=PROJECT.Pnumber group by Pnumber;

#5
select Pnumber,Pname,Plocation,count(Essn) from PROJECT inner join WORKS_ON on WORKS_ON.Pno=PROJECT.Pnumber where Dnum=5 group by Pnumber;

#6
select Pnumber,Dnum, Lname,Address from PROJECT join DEPARTMENT on DEPARTMENT.Dnumber=PROJECT.Dnum join EMPLOYEE on EMPLOYEE.Ssn=DEPARTMENT.Mgr_ssn where Plocation='Houston';

#7
select Fname,Lname,Pname from EMPLOYEE join WORKS_ON on EMPLOYEE.Ssn=WORKS_ON.Essn join PROJECT on WORKS_ON.Pno=PROJECT.Pnumber order by Dnum ASC, Fname ASC, Lname ASC;

#8
select * from EMPLOYEE where Super_ssn is NULL;

#9
select * from EMPLOYEE where Super_ssn in (select Ssn from EMPLOYEE where Super_ssn=987654321);

#10
select e.Fname Fname,e.Lname Lname from EMPLOYEE e join EMPLOYEE e1 on e.Super_ssn=e1.Ssn where e1.Super_ssn=987654321;

#11
select e.Fname,e.Lname,e1.Fname supervisor_fname,e1.Lname supervisor_lname,e.Salary salary FROM EMPLOYEE e JOIN EMPLOYEE e1 ON e.Super_ssn =e1.Ssn where e.Dno = (select Dnumber FROM DEPARTMENT where Dname="Research" );

#12
select Pname,Dname,count(*) NoEmp,SUM(Hours) Total_hours from PROJECT join DEPARTMENT on PROJECT.Dnum=DEPARTMENT.Dnumber join WORKS_ON on WORKS_ON.Pno=PROJECT.Pnumber group by Pnumber having count(*)>1;

#13
select Pname,Dname,count(*) NoEmp,SUM(Hours) Total_hours from PROJECT join DEPARTMENT on PROJECT.Dnum=DEPARTMENT.Dnumber join WORKS_ON on WORKS_ON.Pno=PROJECT.Pnumber group by Pnumber having count(*)>1;

#14
select Fname,Lname from EMPLOYEE where Ssn = all(select Essn from WORKS_ON join PROJECT on WORKS_ON.Pno=PROJECT.Pnumber and Dnum=5);

#15
select Fname from EMPLOYEE,WORKS_ON,PROJECT where EMPLOYEE.Ssn=WORKS_ON.Essn and WORKS_ON.Pno=PROJECT.Pnumber and PROJECT.Pname='ProductX';

#16
select Fname from EMPLOYEE,DEPENDENT where EMPLOYEE.Fname=DEPENDENT.Dependent_name;

#17
select e1.Fname from EMPLOYEE e1,EMPLOYEE e2 where e1.Super_ssn=e2.Ssn and e2.Fname='Franklin' and e2.Lname='Wong';

#18	
select Pname,sum(Hours) from PROJECT inner join WORKS_ON on PROJECT.Pnumber=WORKS_ON.Pno group by Pno;

#19
select AVG(Salary) from EMPLOYEE where Sex='F' group by Sex;
