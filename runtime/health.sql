\set ON_ERROR_STOP on
SELECT current_database() AS database_name, current_user AS user_name;
SELECT shobj_description(oid, 'pg_database') AS package_marker
FROM pg_database WHERE datname = current_database();
