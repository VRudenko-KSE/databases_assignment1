\set ON_ERROR_STOP on
SELECT current_database() = 'postgres'
   AND current_user = 'student'
   AND :'confirm_reset' = 'assignment1'
   AND EXISTS (
       SELECT 1 FROM pg_database
       WHERE datname = 'assignment1'
         AND shobj_description(oid, 'pg_database') = 'kse-assignment-1-package:v0.1.0'
   ) AS reset_allowed
\gset
\if :reset_allowed
  DROP DATABASE assignment1 WITH (FORCE);
  CREATE DATABASE assignment1 OWNER student;
  COMMENT ON DATABASE assignment1 IS 'kse-assignment-1-package:v0.1.0';
  ALTER DATABASE assignment1 SET timezone TO 'UTC';
  \echo Reset assignment1; host SQL files and pgAdmin settings were preserved.
\else
  DO $$ BEGIN
    RAISE EXCEPTION 'Reset refused: check connection, package marker, and confirm_reset=assignment1';
  END $$;
\endif
