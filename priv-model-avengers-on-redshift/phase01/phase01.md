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
- [phase01_create_user.sql] (./phase01_create_user.sql) - Creates users on the cluster
- [phase01_create_schema_groups.sql] (./phase01_create_schema_groups.sql) - Setup schemas and corresponding Create, Read/Write and ReadOnly user groups on the cluster.
- [phase01_create_group_membership.sql] (./phase01_create_group_membership.sql) - Establish group membership of the for the users.

## Test access and behavior.
### Create tables with two creators of shield schema
1. Create table 'tbl01_iron_man' in shield schema as iron_man
```sql
select current_user;
create table shield.tbl01_iron_man (cols int);
```
1. Create table 'tbl01_fury' in shield schema as fury
```sql
select current_user;
create table shield.tbl01_fury (cols int);
```

#### Test the access to the creators on each other's tables
1. As iron_man test access to the table shield.tbl01_fury
```sql
select * from shield.tbl01_fury;
```
1. As fury test access to the table shield.tbl01_iron_man
```sql
select * from shield.tbl01_iron_man;
```

# TODO Test ReadWrite access user and continue from Step 4 onwards in the doc.
#### Test the access to the ReadWrite and ReadOnly users
1. As captain_america
