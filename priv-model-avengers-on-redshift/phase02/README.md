## Phase02

| User\Schema | avengers_tower | shield | wakanda | avengers_facility |  kamar_taj |
| :---------- | :------------- | :------| :------ | :---------------- |  :-------- |
| iron_man    | C              | C      |         | C                 |            |
| captain_america | RO         | ~~RW~~RO |       |                   |            |
| loki        |                |        |         |                   |            |
| thor        | RO             | RO     |         |                   |            |
| hulk        | RW             | C      |         |                   |            |
| shuri       |                |        | C       |                   |            |
| blackpanther |               |        | RW      |                   |            |
| fury        | RO             | C      |         | RW                |            |
| spider_man  |                |        |         | RW                |            |
| ancient_one |                |        |         |                   |  C         |
| doctor_strange |             |        |         |                   |  RO        |

#### Change existing user privileges
Change 'captain_america' from 'ReadWrite' to be 'ReadOnly' on 'shield' schema using the script - [phase02_make_capatain_america_readonly.sql](./phase02_make_capatain_america_readonly.sql)

Test the privileges of captain_america
```sql
select current_user;
-- Tables created by iron_man
select * from  shield.tbl01_iron_man ;
select * from  shield.tbl02_iron_man ;
-- Tables created by fury
select * from shield.tbl01_fury;
select * from shield.tbl02_fury;

-- Since captain_america is ReadOnly user the DML statements should throw an error.
insert into shield.tbl01_iron_man values (1);
insert into shield.tbl02_iron_man values (1);
insert into shield.tbl01_fury values (1);
insert into shield.tbl02_fury values (1);
```
**Output** Since captain_america is a member of ReadOnly group SELECT statements should be successful and INSERT statements should fail
```
rshiftdb=> select current_user;
  current_user   
-----------------
 captain_america
(1 row)

rshiftdb=> -- Tables created by iron_man
rshiftdb=> select * from  shield.tbl01_iron_man ;
 cols
------
    1
(1 row)

rshiftdb=> select * from  shield.tbl02_iron_man ;
 cols
------
    1
(1 row)

rshiftdb=> -- Tables created by fury
rshiftdb=> select * from shield.tbl01_fury;
 cols
------
    1
(1 row)

rshiftdb=> select * from shield.tbl02_fury;
 cols
------
    1
(1 row)

rshiftdb=>
rshiftdb=> -- Since captain_america is ReadOnly user the DML statements should throw an error.
rshiftdb=> insert into shield.tbl01_iron_man values (1);
ERROR:  permission denied for relation tbl01_iron_man
rshiftdb=> insert into shield.tbl02_iron_man values (1);
ERROR:  permission denied for relation tbl02_iron_man
rshiftdb=> insert into shield.tbl01_fury values (1);
ERROR:  permission denied for relation tbl01_fury
rshiftdb=> insert into shield.tbl02_fury values (1);
ERROR:  permission denied for relation tbl02_fury
```

#### Create new table in 'avengers_facility' as 'iron_man'
Login as iron_man and create a table 'avengers_facility.tbl01_iron_man'. This table will be used to test privs/access for the user 'spider_man' that will be created in the below step.
```sql
select current_user;
create table avengers_facility.tbl01_iron_man (col int);
```
**Output**
```
rshiftdb=> select current_user;
 current_user
--------------
 iron_man
(1 row)

rshiftdb=> create table avengers_facility.tbl01_iron_man (col int);
CREATE TABLE
```
**Note:** There were no explicit GRANT statements issued by 'iron_man' to any user or group. These will be taken care by the DEFAULT PRIVILEGES for 'iron_man' on the schema 'avengers_facility'

#### Creation of the user 'spider_man' with ReadWrite privs on the objects in 'avengers_facility'
[phase02_create_user_and_grp_membership_spider_man.sql](./phase02_create_user_and_grp_membership_spider_man.sql) script includes
- Create user
- Alter group statements to make the user 'spider_man' part of avengers_tower_grp_rw group.

After the successful execution of the above script login as 'spider_man' and test the access
```sql
select current_user;
-- Should be possible to select since spider_man is a member of ReadOnly group
select * from avengers_facility.tbl01_iron_man;
-- Insert on the table should fail.
insert into avengers_facility.tbl01_iron_man values (1);
```
**Output** Both SELECT and INSERT statements should be successful as spider_man is a member of ReadWrite group
```
rshiftdb=> select current_user;
 current_user
--------------
 spider_man
(1 row)

rshiftdb=> -- Should be possible to select since spider_man is a member of ReadOnly group
rshiftdb=> select * from avengers_facility.tbl01_iron_man;
 col
-----
(0 rows)

rshiftdb=> -- Insert on the table should fail.
rshiftdb=> insert into avengers_facility.tbl01_iron_man values (1);
INSERT 0 1
```

#### Creation of New schema 'kamar_taj' and corresponding groups
[phase02_create_schema_kamar_taj.sql](./phase02_create_schema_kamar_taj.sql) - includes statements to create new schema and corresponding Create, ReadWrite and ReadOnly Groups
- Schema - kamar_taj
- Create Group - kamar_taj_grp_c
- ReadWrite Group - kamar_taj_grp_rw
- ReadOnly Group - kamar_taj_grp_ro

#### Creation of new user 'ancient_one'
[phase02_create_user_and_grp_membership_ancient_one.sql](./phase02_create_user_and_grp_membership_ancient_one.sql) has the following statements:
- Create User 'ancient_one'
- Add the user to the group 'kamar_taj_grp_c'
- Alter Default privs for the user 'ancient_one' on the schema 'kamar_taj'

After the successful execution of the above script, login as 'ancient_one' and create table 'kamar_taj.tbl01_ancient_one'
```sql
select current_user;
create table kamar_taj.tbl01_ancient_one (col int);
```
**Output**
```
rshiftdb=> select current_user;
 current_user
--------------
 ancient_one
(1 row)

rshiftdb=> create table kamar_taj.tbl01_ancient_one (col int);
CREATE TABLE
```
**Note:** No explicit grants were issued. The DEFAULT PRIVILEGES of 'ancient_one' on the schema 'kamar_taj' should issue the grants.

#### Creation of new user 'doctor_strange'
[phase02_create_user_and_grp_membership_doctor_strange.sql](./phase02_create_user_and_grp_membership_doctor_strange.sql) has the following statements:
- Create User 'doctor_strange'
- Add the user to the group 'kamar_taj_grp_ro'

After the successful execution of the above script, login as doctor_strange and test the access
```sql
select current_user;
-- Should be able to select from kamar_taj.tbl01_ancient_one because ReadOnly member
select * from kamar_taj.tbl01_ancient_one;
-- Insert into kamar_taj.tbl01_ancient_one should fail
insert into kamar_taj.tbl01_ancient_one values (1);
```
**Output** Since doctor_strange is a ReadOny member SELECT statement should be successful but not INSERT statement. 
```
rshiftdb=> select current_user;
  current_user  
----------------
 doctor_strange
(1 row)

rshiftdb=> -- Should be able to select from kamar_taj.tbl01_ancient_one because ReadOnly member
rshiftdb=> select * from kamar_taj.tbl01_ancient_one;
 col
-----
(0 rows)

rshiftdb=> -- Insert into kamar_taj.tbl01_ancient_one should fail
rshiftdb=> insert into kamar_taj.tbl01_ancient_one values (1);
ERROR:  permission denied for relation tbl01_ancient_one
```
