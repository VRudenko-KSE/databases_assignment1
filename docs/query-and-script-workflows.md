# Assignment 1 query and script workflows

## Start and connect

From this package directory, copy `.env.example` to `.env` and change passwords
if needed.
Start the independent environment:

```sh
docker compose up -d --wait
docker compose ps
```

PostgreSQL is available only on `127.0.0.1:55432` by default. Open pgAdmin at
<http://127.0.0.1:55050>; sign in with `PGADMIN_DEFAULT_EMAIL` and
`PGADMIN_DEFAULT_PASSWORD` from `.env`. The preloaded **KSE Assignment 1**
server connects inside Docker as host `db`, port `5432`, database `assignment1`,
user `student`. Its database password is `POSTGRES_PASSWORD`.

The host port is for programs on your computer. The `db:5432` address is for
containers only.
Your SQL files are host files under `submission/` and are read-only at
`/submission/` inside PostgreSQL. Supplied CSV data is `/data` and runtime
scripts are `/runtime`; both mounts are read-only.

## Run SQL and capture a transcript

Put your four files at `submission/schema.sql`, `load.sql`,
`queries.sql`, and `verification.sql`.
On a fresh assignment database, replay them in order:

Use the command for your host shell. Both commands capture standard output and
standard error in the submission evidence file and report the replay's exit
status.

### PowerShell

<!-- rumdl-disable MD013 -->

```powershell
docker compose exec -T db psql -X -a -U student -d assignment1 -v ON_ERROR_STOP=1 -f /runtime/run.sql 2>&1 |
    Tee-Object -FilePath ./submission/evidence/verification.txt
$assignmentRunExit = $LASTEXITCODE
Write-Output "psql exit code: $assignmentRunExit"
```

<!-- rumdl-enable MD013 -->

This PowerShell route is provided for Windows users but has not been tested on a
Windows host in this package checkpoint. If the installed PowerShell writes a
non-UTF-8 default encoding, export the transcript as UTF-8.

### macOS/Linux Bash

<!-- rumdl-disable MD013 -->

```bash
set -o pipefail
docker compose exec -T db psql -X -a -U student -d assignment1 -v ON_ERROR_STOP=1 -f /runtime/run.sql 2>&1 |
  tee submission/evidence/verification.txt
assignment_run_exit=$?
printf 'Replay pipeline exit code: %s\n' "$assignment_run_exit"
```

<!-- rumdl-enable MD013 -->

`-a` echoes SQL into the transcript. The transcript is intentionally replaced by
the chosen run; keep earlier attempts elsewhere if wanted. Inspect the output:
the three intentional errors and the unchanged state matter, and the final exit
status is not proof that those demonstrations were correct. The replay script
does not reset the database or grade your submission; rerun it only when your
schema/load scripts can safely be run against the current database.

Check the independent environment and package marker:

```sh
docker compose exec -T db psql -X -U student -d assignment1 \
  -v ON_ERROR_STOP=1 -f /runtime/health.sql
```

Use pgAdmin's Query Tool for one-off queries, then save durable submission SQL
under `submission/` so the same files can be replayed.

## Stop, restart, and reset

Stopping preserves the database and pgAdmin state:

```sh
docker compose stop
docker compose start
```

Reset is deliberately separate. Close any pgAdmin Query Tool tabs connected to
`assignment1`, because reset terminates its connections, then run:

```sh
docker compose exec -T db psql -X -U student -d postgres \
  -v ON_ERROR_STOP=1 -v confirm_reset=assignment1 -f /runtime/reset.sql
```

The reset refuses a wrong database, wrong user, wrong confirmation, or a
database without the assignment package marker. It recreates only `assignment1`;
it preserves host SQL files, pgAdmin state, and other databases. Afterward
reconnect
to `assignment1` and replay from a fresh database.

## Diagnose failures

If `psql` reports a SQL error, the environment is running and the message
identifies SQL or data to correct. If `docker compose up`, `psql` connection, or
pgAdmin fails before SQL begins, inspect service state and logs:

```sh
docker compose ps
docker compose logs db pgadmin
```

Port conflicts are host-environment errors: choose unused `POSTGRES_PORT` and
`PGADMIN_PORT` values in `.env`, then start again.
