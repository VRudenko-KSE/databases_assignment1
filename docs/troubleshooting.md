# Troubleshooting

Run commands from the supplied Assignment 1 folder containing `compose.yaml`; quote a path with spaces. Use `docker
compose ps` and `docker compose logs db pgadmin` before changing anything.

**Docker engine stopped or command missing:** start Docker Desktop, wait for its engine, open a new terminal, then
run `docker version` and `docker compose version`. Use the OS guide's official installer route; do not install host
PostgreSQL.
**Port already in use:** choose unused `POSTGRES_PORT` and `PGADMIN_PORT` values in `.env`, then run `docker compose
up -d --wait`. `.env` changes made after first initialization do not change stored passwords; restore old values or,
only if you accept loss of this assignment container state, use the scoped reset procedure.
**Wrong password/database:** pgAdmin web login uses its `PGADMIN_*` values; database access uses `POSTGRES_PASSWORD`,
database `assignment1`, and user `student`. pgAdmin's internal server is `db:5432`; host clients use `localhost` and
`POSTGRES_PORT`.
**Missing registration after interrupted initialization:** inspect `docker compose ps`, logs, and the named
`assignment1` database before repair. Do not use broad Docker pruning. If the package marker or database is absent,
follow the reset error message or use the supported course machine.
**Missing host file or wrong path:** host submission files are `submission/...`; container paths are
`/submission/...`. Data is `/data`; runtime is `/runtime`. Save first, then use
the matching container path.
**`.sql.txt` or encoding issue:** show filename extensions on Windows and rename the exact file to end once in
`.sql`. Save scripts as UTF-8 plain text. `psql` meta-commands such as `\i` cannot run in pgAdmin Query Tool.
**Reset refuses confirmation:** reset intentionally requires `-d postgres -v confirm_reset=assignment1`; it recreates
only marked `assignment1`. Do not change its confirmation text or run a broad volume cleanup.
**Unexpected SQL failure:** read the first `ON_ERROR_STOP` error, correct the student SQL or documented dirty-data
handling, reset when ready, and replay. An environment connection failure is different from SQL failure.
**Intentional demonstration error missing or wrong:** inspect the exact SQL operation, PostgreSQL error, named
constraint, and before/after state. Successful script execution alone is not proof.
**Release metadata unavailable:** exact dates, Moodle activity, archive size, support route, and platform-test status
are release information. Do not invent them; use the release announcement or contact the course team.
