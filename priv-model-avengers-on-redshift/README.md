# Avengers on Redshift
One of the important aspects of any Database/Data Warehouse systems is ensuring that users have appropriate permissions on various DB objects all times.
Hence, it privilege management becomes an important aspect of any DB based system.

Demonstrates how Redshift User Groups and users membership can be used to manage access to different schemas easily.
1. [phase01](./phase01)
  - Initial setup of users, user groups and privileges.
  - Run the tests to verify the access
  - Make necessary ALTER DEFAULT PRIVILEGES changes
  - Test the access again
1. [phase02](./phase02)

  Prerequisites - Completion of [phase01](./phase01).

  In this phase following actions are performed:
  - Privilege of 'captain_america' will be modified
  - User 'spider_man' is created with access to one of the existing schemas
  - A new schema 'kamar_taj' and corresponding groups are created. Two new users are also created with appropriate access to that schema.
1. [phase03](./phase03)

  Prerequisites - Completion of [phase02](./phase02).

  In this phase following actions are performed:
  - Privilege of 'iron_man' will be modified
  - Privilege of 'spider_man' will be modified
  - Privilege of 'doctor_strange' will be modified
  - User 'ancient_one' will be dropped.

#### Inference
User Groups can be used to easily manage access to different database objects within a Redshift database.
ALTER DEFAULT PRIVS for a specific user can be used to eliminate the need to write necessary GRANT statements explicitly every time a new object is created.
It involves one time effort to configure user's default privilege and totally eliminates the need for administrator of the Redshift cluster to be involved with every new table created.

The privilege model discussed here is generic in nature providing three levels of access - Create, ReadWrite and ReadOnly and is not limited to Redshift native users in its application.
It is compatible with the recent Redshift's Federated access.

### Object Ownership
Different objects that users can created in Redshift are - Tables, Views and UDFs. Irrespective of the object type there can be only one *OWNER* that will be the owner of the object.
An object cannot be owned by a GROUP.
Other users who need access to the objects need to be authorized by having appropriate privileges granted.

### Granting Privileges to a User on Redshift
Privileges in Redshift to a user can be granted in two ways
- Explicitly granted to the user
- Granted to a User Group that the user is a member of.
GROUP Membership of a user can be maintained using [ALTER GROUP](https://docs.aws.amazon.com/redshift/latest/dg/r_ALTER_GROUP.html)

### DATABASE level privileges
- CREATE - CREATE allows users to create schemas within the database.
- TEMPORARY | TEMP - Grants the privilege to create temporary tables in the specified database.

### SCHEMA level privileges
- CREATE - CREATE allows users to create objects within a schema. To rename an object, the user must have the CREATE privilege and own the object to be renamed.

- USAGE - Can be granted to a USER or GROUP. Allows the user access objects in a schema.
Note: This is the prerequisite to access object within a schema. This is a **necessary** privilege that a user should have (either via explicit grant or inherited via group) but not **sufficient** to actually use the object in a schema.

### TABLE level privileges
- SELECT - Grants privilege to select data from a table or view using a SELECT statement.
- INSERT - Grants privilege to load data into a table using an INSERT statement or a COPY statement.
- UPDATE - Grants privilege to update a table column using an UPDATE statement. UPDATE operations also require the SELECT privilege, because they must reference table columns to determine which rows to update, or to compute new values for columns.
- DELETE - Grants privilege to delete a data row from a table. DELETE operations also require the SELECT privilege, because they must reference table columns to determine which rows to delete.
- REFERENCES - Grants privilege to create a foreign key constraint. This privilege must be present on both the referenced table and the referencing table; otherwise, the user cannot create the constraint.
