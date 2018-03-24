### Phase01 - Privilege model setup
| User\Schema | avengers_tower | shield | wakanda | avengers_facility |
| :---------- | :------------- | :------| :------ | :---------------- |
| iron_man    | C              | C      |         | C                 |
| captain_america | RO         | RW     |         |                   |
| loki        |                |        |         |                   |
| thor        | RO             | RO     |         |                   |
| hulk        | RW             | C      |         |                   |
| shuri       |                |        | C       |                   |
| blackpanther |               |        | RW      |                   |
| fury        | RO             | C      |         | RW                |


Setup - Scripts can be executed in the below order
- [phase01_create_user.sql](./phase01_create_user.sql) - Creates users on the cluster
- [phase01_create_schema_groups.sql](./phase01_create_schema_groups.sql) - Setup schemas and corresponding Create, Read/Write and ReadOnly user groups on the cluster.
- [phase01_create_group_membership.sql](./phase01_create_group_membership.sql) - Establish group membership of the for the users.

## Test access and behavior.
### Create tables with two creators of shield schema
- Create table 'tbl01_iron_man' in shield schema as iron_man
```sql
select current_user;
create table shield.tbl01_iron_man (cols int);
```
**Output**
```
rshiftdb=> select current_user;
 current_user
--------------
 iron_man
(1 row)

rshiftdb=> create table shield.tbl01_iron_man (cols int);
CREATE TABLE
```

- Create table 'tbl01_fury' in shield schema as fury
```sql
select current_user;
create table shield.tbl01_fury (cols int);
```
**Output**
```
rshiftdb=> select current_user;
 current_user
--------------
 fury
(1 row)

rshiftdb=> create table shield.tbl01_fury (cols int);
CREATE TABLE
```

#### Test the access to the creators on each other's tables
- As iron_man test access to the table shield.tbl01_fury
```sql
select * from shield.tbl01_fury;
```
**Output** should be permission denied as below
```
rshiftdb=> select current_user;
 current_user
--------------
 iron_man
(1 row)

rshiftdb=> select * from shield.tbl01_fury;
ERROR:  permission denied for relation tbl01_fury
```
- As fury test access to the table shield.tbl01_iron_man
```sql
select * from shield.tbl01_iron_man;
```
**Output** should be permission denied as below
```
rshiftdb=> select current_user;
 current_user
--------------
 fury
(1 row)

rshiftdb=> select * from shield.tbl01_iron_man;
ERROR:  permission denied for relation tbl01_iron_man
```

#### Test the access to the ReadWrite and ReadOnly users
- As captain_america execute the below statements
```sql
select current_user;
select * from  shield.tbl01_iron_man ;
select * from shield.tbl01_fury;
```
**Output** should be permission denied as below
```
rshiftdb=> select current_user;
  current_user   
-----------------
 captain_america
(1 row)

rshiftdb=> select * from  shield.tbl01_iron_man ;
ERROR:  permission denied for relation tbl01_iron_man
rshiftdb=> select * from shield.tbl01_fury;
ERROR:  permission denied for relation tbl01_fury
```
- As thor execute the below statements
```sql
select current_user;
select * from  shield.tbl01_iron_man ;
select * from shield.tbl01_fury;
```
**Output** should be permission denied as below
```
rshiftdb=> select current_user;
 current_user
--------------
 thor
(1 row)

rshiftdb=> select * from  shield.tbl01_iron_man ;
ERROR:  permission denied for relation tbl01_iron_man
rshiftdb=> select * from shield.tbl01_fury;
ERROR:  permission denied for relation tbl01_fury
```


#### Grant privs on the tables created to the groups appropriately
- Granting privs on shield.tbl01_iron_man
```sql
GRANT ALL ON shield.tbl01_iron_man TO avengers_tower_grp_c;
GRANT INSERT, UPDATE, DELETE, SELECT ON shield.tbl01_iron_man TO avengers_tower_grp_rw;
GRANT SELECT ON shield.tbl01_iron_man TO avengers_tower_grp_ro;
```
- Granting privs on shield.tbl01_fury
```sql
GRANT ALL ON shield.tbl01_fury TO avengers_tower_grp_c;
GRANT INSERT, UPDATE, DELETE, SELECT ON shield.tbl01_fury TO avengers_tower_grp_rw;
GRANT SELECT ON shield.tbl01_fury TO avengers_tower_grp_ro;
```
Repeat the above statements to test access again.


#### Configure Default privileges for creators of respective schemas.

Run the script to ALTER DEFAULT privs for creators of tables in respective tables [phase01_alter_default_privs_for_creators.sql](./phase01_alter_default_privs_for_creators.sql)

## Test access and behavior.
### Create tables with two creators of shield schema
- Create table 'tbl02_iron_man' in shield schema as iron_man
```sql
select current_user;
create table shield.tbl02_iron_man (cols int);
```
- Create table 'tbl02_fury' in shield schema as fury
```sql
select current_user;
create table shield.tbl02_fury (cols int);
```

#### Test the access to the creators on each other's tables
- As iron_man test access to the table shield.tbl02_fury
```sql
select * from shield.tbl02_fury;
```
- As fury test access to the table shield.tbl02_iron_man
```sql
select * from shield.tbl02_iron_man;
```
#### Test the access to the ReadWrite and ReadOnly users
- As captain_america run the below SQL statements
```sql
select current_user;
-- Tables created by iron_man
select * from  shield.tbl01_iron_man ;
select * from  shield.tbl02_iron_man ;
-- Tables created by fury
select * from shield.tbl01_fury;
select * from shield.tbl02_fury;

-- Since captain_america is ReadWrite user test DML statements for successful completion
insert into shield.tbl01_iron_man values (1);
insert into shield.tbl02_iron_man values (1);
insert into shield.tbl01_fury values (1);
insert into shield.tbl02_fury values (1);
```
- As thor run the below SQL statements
```sql
select current_user;
-- Tables created by iron_man
select * from  shield.tbl01_iron_man ;
select * from  shield.tbl02_iron_man ;


-- Tables created by fury
select * from shield.tbl01_fury;
select * from shield.tbl02_fury;
-- Since captain_america is ReadWrite user test DML statements for permission denied messages
insert into shield.tbl01_iron_man values (2);
insert into shield.tbl02_iron_man values (2);
insert into shield.tbl01_fury values (2);
insert into shield.tbl02_fury values (2);
```

#### Test the access for loki (Not a member of any group)
- As loki run the below SQL statements
```sql
select current_user;
-- Tables created by iron_man
select * from  shield.tbl01_iron_man ;
select * from  shield.tbl02_iron_man ;
-- Tables created by fury
select * from shield.tbl01_fury;
select * from shield.tbl02_fury;
```
