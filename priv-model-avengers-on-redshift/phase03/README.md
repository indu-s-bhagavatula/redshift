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


#### Dropping 'ancient_one' user.
Before a user in Redshift can be dropped following are needed to be done:
- Identify the new owner of the object. In this case it will be 'doctor_strange'.


- Transfer the objects 'Owned' by the user to be dropped to another user.
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
