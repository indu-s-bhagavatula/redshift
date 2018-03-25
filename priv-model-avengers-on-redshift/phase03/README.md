## Phase03

| User\Schema | avengers_tower | shield | wakanda | avengers_facility |  kamar_taj |
| :---------- | :------------- | :------| :------ | :---------------- |  :-------- |
| iron_man    | C              | C      |         | C                 |  RO        |
| captain_america | RO         | RO     |         |                   |            |
| loki        |                |        |         |                   |            |
| thor        | RO             | RO     |         |                   |            |
| hulk        | RW             | C      |         |                   |            |
| shuri       |                |        | C       |                   |            |
| blackpanther |               |        | RW      |                   |            |
| fury        | RO             | C      |         | RW                |            |
| spider_man  |                |        |         | ~~RW~~C           |            |
| ~~ancient_one~~ |            |        |         |                   |  ~~C~~     |
| doctor_strange |             |        |         |                   |  ~~RO~~C  |

#### Adding iron_man to kamar_taj_grp_ro group
[phase03_make_iron_man_readonly.sql](./phase03_make_iron_man_readonly.sql) adds 'iron_man' to 'kamar_taj_grp_ro'.

After the successful execution of the above script login as 'iron_man' and test the access
```sql
select current_user;
-- Should be possible to select since iron_man is a member of ReadOnly group
select * from kamar_taj.tbl01_ancient_one;
-- iron_man insert into statement will fail
insert into kamar_taj.tbl01_ancient_one values (1);
```
**Output** iron_man is a member of kamar_taj_grp_ro group. So, SELECT statements should be successful but INSERT INTO statements should fail
```
rshiftdb=> select current_user;
 current_user
--------------
 iron_man
(1 row)

rshiftdb=> -- Should be possible to select since iron_man is a member of ReadOnly group
rshiftdb=> select * from kamar_taj.tbl01_ancient_one;
 col
-----
(0 rows)

rshiftdb=> -- iron_man insert into statement will fail
rshiftdb=> insert into kamar_taj.tbl01_ancient_one values (1);
ERROR:  permission denied for relation tbl01_ancient_one
```
#### Adding spider_man to avengers_facility_c group
[phase03_make_spider_man_creator.sql](./phase03_make_spider_man_creator.sql) contains statement to add
- 'spider_man' to 'avengers_facility_grp_c'
- ALTER DEFAULT PRIVILEGES for 'spider_man' on 'avengers_facility' schema.
- Alter group 'avengers_facility_grp_ro' to remove 'doctor_strange'

After the successful execution of the above script login as 'iron_man' and test the access
```sql
select current_user;
-- Should be possible to create a table in avengers_facility schema because part of avengers_facility_c group
create table avengers_facility.tbl01_spider_man (col int);
```
**Output** spider_man is a member of avengers_facility_grp_c, should be able to create the table
```
rshiftdb=> select current_user;
 current_user
--------------
 spider_man
(1 row)

rshiftdb=> -- Should be possible to create a table in avengers_facility schema because part of avengers_facility_c group
rshiftdb=> create table avengers_facility.tbl01_spider_man (col int);
CREATE TABLE
```
#### Altering 'doctor_strange' as the creator
[phase03_make_doctor_strange_creator.sql](./phase03_make_doctor_strange_creator.sql) contains statement to add
- 'doctor_strange' to 'kamar_taj_grp_c'
- ALTER DEFAULT PRIVILEGES for 'doctor_strange' on 'kamar_taj' schema.
- Alter group 'kamar_taj_grp_ro' to remove 'doctor_strange'

After the successful execution of the above script login as 'doctor_strange' and test the access
```sql
select current_user;
-- Should be possible to create a table in kamar_taj schema because part of kamar_taj_grp_c group
create table kamar_taj.tbl01_doctor_strange (col int);
```
**Output**
```
rshiftdb=> select current_user;
  current_user  
----------------
 doctor_strange
(1 row)

rshiftdb=> -- Should be possible to create a table in kamar_taj schema because part of kamar_taj_grp_c group
rshiftdb=> create table kamar_taj.tbl01_doctor_strange (col int);
```

#### Dropping 'ancient_one' user
Before a user in Redshift can be dropped following are needed to be done:
As master user of the Redshift cluster create the views available here
- [v_find_dropuser_objs.sql](https://github.com/awslabs/amazon-redshift-utils/blob/master/src/AdminViews/v_find_dropuser_objs.sql)
- [v_generate_user_grant_revoke_ddl.sql](https://github.com/awslabs/amazon-redshift-utils/blob/master/src/AdminViews/v_generate_user_grant_revoke_ddl.sql).

After the above views were created successfully execute the below statements as the master user of the cluster
- Identifying objects owned by 'ancient_one'
```sql
-- Identifying the list of all objects that ancient_one owns
select ddl from admin.v_find_dropuser_objs where objowner='ancient_one';
-- Save the output from ddl column in a new_owner.sql and modify it to include doctor_strange
```
**Output** Save the output to a file new_owner.sql
```
rshiftdb=# select ddl from admin.v_find_dropuser_objs where objowner='ancient_one';
                        ddl                        
---------------------------------------------------
 alter table kamar_taj.tbl01_ancient_one owner to
```

- Identifying privileges that were issued by 'ancient_one' that need to be granted by the new owner.
```sql
-- Identifying the list of all objects that ancient_one has issued grants to other groups/users
select ddl from admin.v_generate_user_grant_revoke_ddl where grantor='ancient_one' and ddltype='grant' and objtype <> 'Default ACL';
-- Save the output from ddl column in a reissue_new_owner_grants.sql
```
**Output**  Save the output from ddl column in a file reissue_new_owner_grants.sql
```
rshiftdb=# select ddl from admin.v_generate_user_grant_revoke_ddl where grantor='ancient_one' and ddltype='grant' and objtype <> 'Default ACL';
                                    ddl                                    
---------------------------------------------------------------------------
 grant SELECT on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_rw;
 grant DELETE on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_rw;
 grant INSERT on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_rw;
 grant UPDATE on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_rw;
 grant SELECT on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_c;
 grant DELETE on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_c;
 grant INSERT on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_c;
 grant UPDATE on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_c;
 grant REFERENCES on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_c;
 grant SELECT on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_ro;
(10 rows)
```
- Identifying privileges that were issued by 'ancient_one' to be revoked
```sql
-- Identifying the list of all privileges that are associated with ancient_one that need to be revoked
select ddl from admin.v_generate_user_grant_revoke_ddl where grantor='ancient_one' and ddltype='revoke';
-- Save the output from ddl column in a revoke_grants.sql
```
**Output** Save the output to a file revoke_grants.sql
```
rshiftdb=# select ddl from admin.v_generate_user_grant_revoke_ddl where grantor='ancient_one' and ddltype='revoke';
                                                         ddl                                                         
---------------------------------------------------------------------------------------------------------------------
revoke all on kamar_taj.tbl01_ancient_one from group kamar_taj_grp_c;
revoke all on kamar_taj.tbl01_ancient_one from group kamar_taj_grp_ro;
revoke all on kamar_taj.tbl01_ancient_one from group kamar_taj_grp_rw;
alter default privileges for user ancient_one in schema kamar_taj revoke all on tables from group kamar_taj_grp_rw;
alter default privileges for user ancient_one in schema kamar_taj revoke all on tables from group kamar_taj_grp_c;
alter default privileges for user ancient_one in schema kamar_taj revoke all on tables from group kamar_taj_grp_ro;

(6 rows)
```

##### Run the above scripts
###### As master user of the cluster run object run the saved script "new_owner.sql" from Step 1.
- **Output**
```
rshiftdb=# alter table kamar_taj.tbl01_ancient_one owner to doctor_strange;
ALTER TABLE
```

###### As doctor_strange of the cluster run object run the saved script "reissue_new_owner_grants.sql" from Step 2.
- **Output** Output from reissuing the privileges
```
rshiftdb=> select current_user;
  current_user  
----------------
 doctor_strange
(1 row)

rshiftdb=> grant SELECT on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_rw;
GRANT
rshiftdb=> grant DELETE on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_rw;
GRANT
rshiftdb=> grant INSERT on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_rw;
GRANT
rshiftdb=> grant UPDATE on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_rw;
GRANT
rshiftdb=> grant SELECT on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_c;
GRANT
rshiftdb=> grant DELETE on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_c;
GRANT
rshiftdb=> grant INSERT on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_c;
GRANT
rshiftdb=> grant UPDATE on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_c;
GRANT
rshiftdb=> grant REFERENCES on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_c;
GRANT
rshiftdb=> grant SELECT on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_ro;
GRANT
rshiftdb=> grant SELECT on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_rw;
GRANT
rshiftdb=> grant DELETE on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_rw;
GRANT
rshiftdb=> grant INSERT on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_rw;
GRANT
rshiftdb=> grant UPDATE on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_rw;
GRANT
rshiftdb=> grant SELECT on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_c;
GRANT
rshiftdb=> grant DELETE on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_c;
GRANT
rshiftdb=> grant INSERT on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_c;
GRANT
rshiftdb=> grant UPDATE on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_c;
GRANT
rshiftdb=> grant REFERENCES on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_c;
GRANT
rshiftdb=> grant SELECT on kamar_taj.tbl01_ancient_one to group kamar_taj_grp_ro;
GRANT
```

###### As master user run the script "revoke_grants.sql" generated from Step 3.
- **Output** Output from revoking the privileges
```
rshiftdb=# revoke all on kamar_taj.tbl01_ancient_one from group kamar_taj_grp_c;
REVOKE
rshiftdb=# revoke all on kamar_taj.tbl01_ancient_one from group kamar_taj_grp_ro;
REVOKE
rshiftdb=# revoke all on kamar_taj.tbl01_ancient_one from group kamar_taj_grp_rw;
REVOKE
rshiftdb=#  alter default privileges for user ancient_one in schema kamar_taj revoke all on tables from group kamar_taj_grp_rw;
ALTER DEFAULT PRIVILEGES
rshiftdb=#  alter default privileges for user ancient_one in schema kamar_taj revoke all on tables from group kamar_taj_grp_c;
ALTER DEFAULT PRIVILEGES
rshiftdb=#  alter default privileges for user ancient_one in schema kamar_taj revoke all on tables from group kamar_taj_grp_ro;
ALTER DEFAULT PRIVILEGES
```

###### Drop the user - ancient_one
- Once the above statements executed successfully, run the below script as master user of the cluster [phase03_drop_user_ancient_one.sql](./phase03_drop_user_ancient_one.sql) includes statements for:
  - Drop user 'ancient_one'
**Output**
```
rshiftdb=# DROP USER ancient_one;
DROP USER
rshiftdb=# select * from pg_user where usename='ancient_one';
 usename | usesysid | usecreatedb | usesuper | usecatupd | passwd | valuntil | useconfig
---------+----------+-------------+----------+-----------+--------+----------+-----------
(0 rows)
```
