begin;
-- ALTER GROUP kamar_taj_grp_c To ADD USER doctor_strange
ALTER GROUP kamar_taj_grp_c ADD USER doctor_strange;

-- Alter def privs of user doctor_strange in schema kamar_taj to authorize create and access privs for members of group kamar_taj_grp_c
ALTER DEFAULT PRIVILEGES FOR USER doctor_strange
IN SCHEMA kamar_taj
GRANT ALL ON TABLES
TO GROUP kamar_taj_grp_c;
-- Alter def privs of user doctor_strange in schema kamar_taj to authorize read write access privs group kamar_taj_grp_rw
ALTER DEFAULT PRIVILEGES FOR USER doctor_strange
IN SCHEMA kamar_taj
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES
TO GROUP kamar_taj_grp_rw;
-- Alter def privs of user doctor_strange in schema kamar_taj  to authorize read access group kamar_taj_grp_ro
ALTER DEFAULT PRIVILEGES FOR USER doctor_strange
IN SCHEMA kamar_taj
GRANT SELECT ON TABLES
TO GROUP kamar_taj_grp_ro;
-- ALTER GROUP kamar_taj_grp_ro To drop USER doctor_strange
ALTER GROUP kamar_taj_grp_ro DROP USER doctor_strange;
end;
