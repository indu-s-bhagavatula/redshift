-- create user doctor_strange
CREATE USER doctor_strange WITH PASSWORD 'Marv3!CU';
-- ALTER GROUP kamar_taj_grp_ro To ADD USER doctor_strange
ALTER GROUP kamar_taj_grp_ro ADD USER doctor_strange;
