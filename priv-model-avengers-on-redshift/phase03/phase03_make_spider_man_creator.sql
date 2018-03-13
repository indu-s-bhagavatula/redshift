begin;
-- ALTER GROUP avengers_facility_grp_c To ADD USER spider_man
ALTER GROUP avengers_facility_grp_c ADD USER spider_man;
-- Alter def privs of user spider_man in schema avengers_facility to authorize create and access privs for members of group avengers_facility_grp_c
ALTER DEFAULT PRIVILEGES FOR USER spider_man
IN SCHEMA avengers_facility
GRANT ALL ON TABLES
TO GROUP avengers_facility_grp_c;
-- Alter def privs of user spider_man in schema avengers_facility to authorize read write access privs group avengers_facility_grp_rw
ALTER DEFAULT PRIVILEGES FOR USER spider_man
IN SCHEMA avengers_facility
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES
TO GROUP avengers_facility_grp_rw;
-- Alter def privs of user spider_man in schema avengers_facility  to authorize read access group avengers_facility_grp_ro
ALTER DEFAULT PRIVILEGES FOR USER spider_man
IN SCHEMA avengers_facility
GRANT SELECT ON TABLES
TO GROUP avengers_facility_grp_ro;
-- ALTER GROUP avengers_facility_grp_ro To drop USER spider_man
ALTER GROUP avengers_facility_grp_ro DROP USER spider_man;
end;
