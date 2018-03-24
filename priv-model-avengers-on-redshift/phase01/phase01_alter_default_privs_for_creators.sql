-- Alter def privs of user iron_man in schema avengers_tower to authorize create and access privs for members of group avengers_tower_grp_c
ALTER DEFAULT PRIVILEGES FOR USER iron_man
IN SCHEMA avengers_tower
GRANT ALL ON TABLES
TO GROUP avengers_tower_grp_c;
-- Alter def privs of user iron_man in schema avengers_tower to authorize read write access privs group avengers_tower_grp_rw
ALTER DEFAULT PRIVILEGES FOR USER iron_man
IN SCHEMA avengers_tower
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES
TO GROUP avengers_tower_grp_rw;
-- Alter def privs of user iron_man in schema avengers_tower  to authorize read access group avengers_tower_grp_ro
ALTER DEFAULT PRIVILEGES FOR USER iron_man
IN SCHEMA avengers_tower
GRANT SELECT ON TABLES
TO GROUP avengers_tower_grp_ro;

-- Alter def privs of user iron_man in schema shield to authorize create and access privs for members of group shield_grp_c
ALTER DEFAULT PRIVILEGES FOR USER iron_man
IN SCHEMA shield
GRANT ALL ON TABLES
TO GROUP shield_grp_c;
-- Alter def privs of user iron_man in schema shield to authorize read write access privs group shield_grp_rw
ALTER DEFAULT PRIVILEGES FOR USER iron_man
IN SCHEMA shield
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES
TO GROUP shield_grp_rw;
-- Alter def privs of user iron_man in schema shield  to authorize read access group shield_grp_ro
ALTER DEFAULT PRIVILEGES FOR USER iron_man
IN SCHEMA shield
GRANT SELECT ON TABLES
TO GROUP shield_grp_ro;

-- Alter def privs of user iron_man in schema avengers_facility to authorize create and access privs for members of group avengers_facility_grp_c
ALTER DEFAULT PRIVILEGES FOR USER iron_man
IN SCHEMA avengers_facility
GRANT ALL ON TABLES
TO GROUP avengers_facility_grp_c;
-- Alter def privs of user iron_man in schema avengers_facility to authorize read write access privs group avengers_facility_grp_rw
ALTER DEFAULT PRIVILEGES FOR USER iron_man
IN SCHEMA avengers_facility
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES
TO GROUP avengers_facility_grp_rw;
-- Alter def privs of user iron_man in schema avengers_facility  to authorize read access group avengers_facility_grp_ro
ALTER DEFAULT PRIVILEGES FOR USER iron_man
IN SCHEMA avengers_facility
GRANT SELECT ON TABLES
TO GROUP avengers_facility_grp_ro;

-- Alter def privs of user hulk in schema shield to authorize create and access privs for members of group shield_grp_c
ALTER DEFAULT PRIVILEGES FOR USER hulk
IN SCHEMA shield
GRANT ALL ON TABLES
TO GROUP shield_grp_c;
-- Alter def privs of user hulk in schema shield to authorize read write access privs group shield_grp_rw
ALTER DEFAULT PRIVILEGES FOR USER hulk
IN SCHEMA shield
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES
TO GROUP shield_grp_rw;
-- Alter def privs of user hulk in schema shield  to authorize read access group shield_grp_ro
ALTER DEFAULT PRIVILEGES FOR USER hulk
IN SCHEMA shield
GRANT SELECT ON TABLES
TO GROUP shield_grp_ro;

-- Alter def privs of user shuri in schema wakanda to authorize create and access privs for members of group wakanda_grp_c
ALTER DEFAULT PRIVILEGES FOR USER shuri
IN SCHEMA wakanda
GRANT ALL ON TABLES
TO GROUP wakanda_grp_c;
-- Alter def privs of user shuri in schema wakanda to authorize read write access privs group wakanda_grp_rw
ALTER DEFAULT PRIVILEGES FOR USER shuri
IN SCHEMA wakanda
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES
TO GROUP wakanda_grp_rw;
-- Alter def privs of user shuri in schema wakanda  to authorize read access group wakanda_grp_ro
ALTER DEFAULT PRIVILEGES FOR USER shuri
IN SCHEMA wakanda
GRANT SELECT ON TABLES
TO GROUP wakanda_grp_ro;

-- Alter def privs of user fury in schema shield to authorize create and access privs for members of group shield_grp_c
ALTER DEFAULT PRIVILEGES FOR USER fury
IN SCHEMA shield
GRANT ALL ON TABLES
TO GROUP shield_grp_c;
-- Alter def privs of user fury in schema shield to authorize read write access privs group shield_grp_rw
ALTER DEFAULT PRIVILEGES FOR USER fury
IN SCHEMA shield
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES
TO GROUP shield_grp_rw;
-- Alter def privs of user fury in schema shield  to authorize read access group shield_grp_ro
ALTER DEFAULT PRIVILEGES FOR USER fury
IN SCHEMA shield
GRANT SELECT ON TABLES
TO GROUP shield_grp_ro;
