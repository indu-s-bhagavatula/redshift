-- Create kamar_taj schema and correpsonding groups with and grant appropriate privileges
CREATE SCHEMA kamar_taj;
-- Create a user group who can create objects in the schema
CREATE GROUP kamar_taj_grp_c;
GRANT CREATE, USAGE ON SCHEMA kamar_taj TO GROUP kamar_taj_grp_c;
-- Create a user group who can read write objects in the schema
CREATE GROUP kamar_taj_grp_rw;
GRANT USAGE ON SCHEMA kamar_taj TO GROUP kamar_taj_grp_rw;
-- Create a user group who can read objects in the schema
CREATE GROUP kamar_taj_grp_ro;
GRANT USAGE ON SCHEMA kamar_taj TO GROUP kamar_taj_grp_ro;
