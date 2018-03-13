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
| doctor_strange |             |        |         |                   |  RO-->C  |

#### Adding iron_man to kamar_taj_grp_ro group
[phase03_make_doctor_strange_creator.sql](./phase03_make_doctor_strange_creator.sql) adds 'iron_man' to 'kamar_taj_grp_ro'.

After the successful execution of the above script login as 'iron_man' and test the access
```sql
select current_user;
-- Should be possible to select since spider_man is a member of ReadOnly group
select * from kamar_taj.tbl01_ancient_one;
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

#### Altering 'doctor_strange' as the creator
[phase03_make_doctor_strange_creator.sql](./phase03_make_doctor_strange_creator.sql) contains statement to add
- 'doctor_strange' to 'kamar_taj_grp_c'
- ALTER DEFAULT PRIVILEGES for 'doctor_strange' on 'kamar_taj' schema.
- Alter group 'kamar_taj_grp_ro' to remove 'doctor_strange'

After the successful execution of the above script login as 'doctor_strange' and test the access
```sql
select current_user;
-- Should be possible to create a table in avengers_facility schema because part of avengers_facility_c group
create table kamar_taj.tbl01_doctor_strange (col int);
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
select ddl from v_find_dropuser_objs where objowner='ancient_one';
-- Save the output from ddl column in a new_owner.sql and modify it to include doctor_strange
```

- Identifying privileges that were issued by 'ancient_one' to be revoked
```sql
-- Identifying the list of all objects that ancient_one has issued grants to other groups/users

-- Save the output from ddl column in a new_owner.sql and modify it to include doctor_strange
```


- Identify the new owner of the object. Transfer the objects 'Owned' by the user to be dropped to another user.
Login as **'ancient_one'** and execute below statements
In this case object ownership will be transferred from 'ancient_one' to 'doctor_strange'. This is a legitimate operation even though doctor_strange is still a member of ReadOnly group.
```sql
select current_user
-- Transfer the ownership of the table to 'doctor_strange'
ALTER TABLE kamar_taj.tbl01_ancient_one OWNER TO doctor_strange;
```
- Have the grants issued as the new user to the Users/Groups

- Revoke privileges granted by the user to other users or groups
- Revoke all the default privileges configured for the user on schema(s) other to users/groups

The first two steps have to be performed as the user 'ancient_one'
```sql
-- Revoke All the privileges granted on various objects
-- In this case kamar_taj.tbl01_ancient_one from groups.
REVOKE ALL ON ALL TABLES IN SCHEMA kamar_taj FROM kamar_taj_grp_c;
REVOKE ALL ON ALL TABLES IN SCHEMA kamar_taj FROM kamar_taj_grp_rw;
REVOKE ALL ON ALL TABLES IN SCHEMA kamar_taj FROM kamar_taj_grp_ro;
-- Transfer the ownership of the table to 'doctor_strange'
ALTER TABLE kamar_taj.tbl01_ancient_one OWNER TO doctor_strange;
```

Once the above statements executed successfully, [phase03_drop_user_ancient_one.sql](./phase03_drop_user_ancient_one.sql) includes statements for:
- Reconfiguring the default privileges for the user 'ancient_one' on the schema 'kamar_taj' for various groups.
- Drop user 'ancient_one'
