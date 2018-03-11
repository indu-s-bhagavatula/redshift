-- create user ancient_one
CREATE USER ancient_one WITH PASSWORD 'Marv3!CU';
-- ALTER GROUP kamar_taj_grp_c To ADD USER ancient_one
ALTER GROUP kamar_taj_grp_c ADD USER ancient_one;
-- Alter def privs of user ancient_one in schema kamar_taj to authorize create and access privs for members of group kamar_taj_grp_c
ALTER DEFAULT PRIVILEGES FOR USER ancient_one
IN SCHEMA kamar_taj
GRANT ALL ON TABLES
TO GROUP kamar_taj_grp_c;
-- Alter def privs of user ancient_one in schema kamar_taj to authorize read write access privs group kamar_taj_grp_rw
ALTER DEFAULT PRIVILEGES FOR USER ancient_one
IN SCHEMA kamar_taj
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES
TO GROUP kamar_taj_grp_rw;
-- Alter def privs of user ancient_one in schema kamar_taj  to authorize read access group kamar_taj_grp_ro
ALTER DEFAULT PRIVILEGES FOR USER ancient_one
IN SCHEMA kamar_taj
GRANT SELECT ON TABLES
TO GROUP kamar_taj_grp_ro;
