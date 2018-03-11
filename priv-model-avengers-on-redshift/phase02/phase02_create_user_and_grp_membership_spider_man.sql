-- create user spider_man
CREATE USER spider_man WITH PASSWORD 'Marv3!CU';
-- ALTER GROUP avengers_facility_grp_rw To ADD USER spider_man
ALTER GROUP avengers_facility_grp_rw ADD USER spider_man;
