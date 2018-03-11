-- Alter Default privileges for the user 'ancient_one' on schema 'kamar_taj' for each group
ALTER DEFAULT PRIVILEGES
FOR USER ancient_one
IN SCHEMA kamar_taj
REVOKE ALL ON TABLES
FROM GROUP kamar_taj_grp_c;
ALTER DEFAULT PRIVILEGES
FOR USER ancient_one
IN SCHEMA kamar_taj
REVOKE ALL ON TABLES
FROM GROUP kamar_taj_grp_rw;
ALTER DEFAULT PRIVILEGES
FOR USER ancient_one
IN SCHEMA kamar_taj
REVOKE ALL ON TABLES
FROM GROUP kamar_taj_grp_ro;

-- Drop the user ancient_one
DROP USER ancient_one;
