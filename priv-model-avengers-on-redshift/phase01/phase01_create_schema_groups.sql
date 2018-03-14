-- Create avengers_tower schema and correpsonding groups with and grant appropriate privileges
CREATE SCHEMA avengers_tower;
-- Create a user group who can create objects in the schema
CREATE GROUP avengers_tower_grp_c;
GRANT CREATE, USAGE ON SCHEMA avengers_tower TO GROUP avengers_tower_grp_c;
-- Create a user group who can read write objects in the schema
CREATE GROUP avengers_tower_grp_rw;
GRANT USAGE ON SCHEMA avengers_tower TO GROUP avengers_tower_grp_rw;
-- Create a user group who can read objects in the schema
CREATE GROUP avengers_tower_grp_ro;
GRANT USAGE ON SCHEMA avengers_tower TO GROUP avengers_tower_grp_ro;

-- Create shield schema and correpsonding groups with and grant appropriate privileges
CREATE SCHEMA shield;
-- Create a user group who can create objects in the schema
CREATE GROUP shield_grp_c;
GRANT CREATE, USAGE ON SCHEMA shield TO GROUP shield_grp_c;
-- Create a user group who can read write objects in the schema
CREATE GROUP shield_grp_rw;
GRANT USAGE ON SCHEMA shield TO GROUP shield_grp_rw;
-- Create a user group who can read objects in the schema
CREATE GROUP shield_grp_ro;
GRANT USAGE ON SCHEMA shield TO GROUP shield_grp_ro;

-- Create wakanda schema and correpsonding groups with and grant appropriate privileges
CREATE SCHEMA wakanda;
-- Create a user group who can create objects in the schema
CREATE GROUP wakanda_grp_c;
GRANT CREATE, USAGE ON SCHEMA wakanda TO GROUP wakanda_grp_c;
-- Create a user group who can read write objects in the schema
CREATE GROUP wakanda_grp_rw;
GRANT USAGE ON SCHEMA wakanda TO GROUP wakanda_grp_rw;
-- Create a user group who can read objects in the schema
CREATE GROUP wakanda_grp_ro;
GRANT USAGE ON SCHEMA wakanda TO GROUP wakanda_grp_ro;

-- Create avengers_facility schema and correpsonding groups with and grant appropriate privileges
CREATE SCHEMA avengers_facility;
-- Create a user group who can create objects in the schema
CREATE GROUP avengers_facility_grp_c;
GRANT CREATE, USAGE ON SCHEMA avengers_facility TO GROUP avengers_facility_grp_c;
-- Create a user group who can read write objects in the schema
CREATE GROUP avengers_facility_grp_rw;
GRANT USAGE ON SCHEMA avengers_facility TO GROUP avengers_facility_grp_rw;
-- Create a user group who can read objects in the schema
CREATE GROUP avengers_facility_grp_ro;
GRANT USAGE ON SCHEMA avengers_facility TO GROUP avengers_facility_grp_ro;
