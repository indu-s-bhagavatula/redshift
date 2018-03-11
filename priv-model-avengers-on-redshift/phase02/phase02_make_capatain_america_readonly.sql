-- ALTER GROUP avengers_tower_grp_rw To drop USER captain_america
ALTER GROUP avengers_tower_grp_rw DROP USER captain_america;
-- ALTER GROUP avengers_tower_ro To ADD USER captain_america
ALTER GROUP avengers_tower_ro ADD USER captain_america;
