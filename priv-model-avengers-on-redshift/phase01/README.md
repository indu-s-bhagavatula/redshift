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
select current_user;
GRANT ALL ON shield.tbl01_iron_man TO GROUP shield_grp_c;
GRANT INSERT, UPDATE, DELETE, SELECT ON shield.tbl01_iron_man TO GROUP shield_grp_rw;
GRANT SELECT ON shield.tbl01_iron_man TO GROUP  shield_grp_ro;
```
**Output** Grant statement should be successful
```
rshiftdb=> select current_user;
 current_user
--------------
 iron_man
(1 row)

rshiftdb=> GRANT ALL ON shield.tbl01_iron_man TO GROUP shield_grp_c;
GRANT
rshiftdb=> GRANT INSERT, UPDATE, DELETE, SELECT ON shield.tbl01_iron_man TO GROUP shield_grp_rw;
GRANT
rshiftdb=> GRANT SELECT ON shield.tbl01_iron_man TO GROUP  shield_grp_ro;
GRANT
```

- Granting privs on shield.tbl01_fury
```sql
select current_user;
GRANT ALL ON shield.tbl01_fury TO GROUP  shield_grp_c;
GRANT INSERT, UPDATE, DELETE, SELECT ON shield.tbl01_fury TO GROUP shield_grp_rw;
GRANT SELECT ON shield.tbl01_fury TO GROUP shield_grp_ro;
```
**Output** Grant statement should be successful
```
rshiftdb=> select current_user;
 current_user
--------------
 fury
(1 row)

rshiftdb=> GRANT ALL ON shield.tbl01_fury TO GROUP  shield_grp_c;
GRANT
rshiftdb=> GRANT INSERT, UPDATE, DELETE, SELECT ON shield.tbl01_fury TO GROUP shield_grp_rw;
GRANT
rshiftdb=> GRANT SELECT ON shield.tbl01_fury TO GROUP shield_grp_ro;
GRANT
```

- Repeat the above statements for each user to test access again.


## Configure Default privileges for creators of respective schemas.

As master user of the cluster run the script to ALTER DEFAULT privs for creators of tables in respective schemas [phase01_alter_default_privs_for_creators.sql](./phase01_alter_default_privs_for_creators.sql)

**Test access and behavior after default privileges are altered.**
### Create tables with two creators of shield schema
- Create table 'tbl02_iron_man' in shield schema as iron_man
```sql
select current_user;
create table shield.tbl02_iron_man (cols int);
```
**Output**
```
rshiftdb=> select current_user;
 current_user
--------------
 iron_man
(1 row)

rshiftdb=> create table shield.tbl02_iron_man (cols int);
CREATE TABLE
```
- Create table 'tbl02_fury' in shield schema as fury
```sql
select current_user;
create table shield.tbl02_fury (cols int);
```
**Output**
```
rshiftdb=> select current_user;
 current_user
--------------
 fury
(1 row)

rshiftdb=> create table shield.tbl02_fury (cols int);
CREATE TABLE
```
#### Test the access to the creators on each other's tables
- As iron_man test access to the table shield.tbl02_fury
```sql
select current_user;
select * from shield.tbl02_fury;
```
**Output** should be able to SELECT from the table even if there aren't explicit GRANT statements executed
```
rshiftdb=> select current_user;
 current_user
--------------
 iron_man
(1 row)

rshiftdb=> select * from shield.tbl02_fury;
 cols
------
(0 rows)
```
- As fury test access to the table shield.tbl02_iron_man
```sql
select current_user;
select * from shield.tbl02_iron_man;
```
**Output** should be able to SELECT from the table even if there aren't explicit GRANT statements executed
```
rshiftdb=> select current_user;
 current_user
--------------
 fury
(1 row)

rshiftdb=> select * from shield.tbl02_iron_man;
 cols
------
(0 rows)
```
#### Test the access to the ReadWrite users - captain_america
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
**Output** All the statements should be successful
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
(0 rows)

rshiftdb=> select * from  shield.tbl02_iron_man ;
 cols
------
(0 rows)

rshiftdb=> -- Tables created by fury
rshiftdb=> select * from shield.tbl01_fury;
 cols
------
(0 rows)

rshiftdb=> select * from shield.tbl02_fury;
 cols
------
(0 rows)

rshiftdb=>
rshiftdb=> -- Since captain_america is ReadWrite user test DML statements for successful completion
rshiftdb=> insert into shield.tbl01_iron_man values (1);
INSERT 0 1
rshiftdb=> insert into shield.tbl02_iron_man values (1);
INSERT 0 1
rshiftdb=> insert into shield.tbl01_fury values (1);
INSERT 0 1
rshiftdb=> insert into shield.tbl02_fury values (1);
INSERT 0 1
```
#### Test the access to the ReadOnly users - thor
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
**Output** All the SELECT statements should be successful but INSERT statements should fail
```
rshiftdb=> select current_user;
 current_user
--------------
 thor
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

rshiftdb=>
rshiftdb=>
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

rshiftdb=> -- Since captain_america is ReadWrite user test DML statements for permission denied messages
rshiftdb=> insert into shield.tbl01_iron_man values (2);
ERROR:  permission denied for relation tbl01_iron_man
rshiftdb=> insert into shield.tbl02_iron_man values (2);
ERROR:  permission denied for relation tbl02_iron_man
rshiftdb=> insert into shield.tbl01_fury values (2);
ERROR:  permission denied for relation tbl01_fury
rshiftdb=> insert into shield.tbl02_fury values (2);
ERROR:  permission denied for relation tbl02_fury
```

#### Test the access for users that are not members of any group - loki
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
**Output** All the SELECT statements should fail
```
rshiftdb=> select current_user;
 current_user
--------------
 loki
(1 row)

rshiftdb=> -- Tables created by iron_man
rshiftdb=> select * from  shield.tbl01_iron_man ;
ERROR:  permission denied for schema shield
rshiftdb=> select * from  shield.tbl02_iron_man ;
ERROR:  permission denied for schema shield
rshiftdb=> -- Tables created by fury
rshiftdb=> select * from shield.tbl01_fury;
ERROR:  permission denied for schema shield
rshiftdb=> select * from shield.tbl02_fury;
ERROR:  permission denied for schema shield
```
