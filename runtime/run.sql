\set ON_ERROR_STOP on
\pset pager off
\pset null '(NULL)'
SET TIME ZONE 'UTC';
SET DateStyle TO 'ISO, YMD';
SELECT current_database() AS database_name, current_user AS user_name;
\echo SCHEMA
\i /submission/schema.sql
\echo LOAD
\i /submission/load.sql
\echo REPORTS
\i /submission/queries.sql
\echo INTEGRITY DEMONSTRATIONS
\set ON_ERROR_STOP off
\i /submission/verification.sql
\set ON_ERROR_STOP on
\echo NOTE: intentional demonstration errors above require manual inspection; the final process exit code is not proof that they were correct.
