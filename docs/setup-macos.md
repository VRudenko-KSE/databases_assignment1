# macOS setup

Use Terminal. PostgreSQL, pgAdmin, and `psql` run in Docker; do not install host PostgreSQL or `psql`. Install and
start the matching Intel or Apple Silicon Docker Desktop from the [official macOS
instructions](https://docs.docker.com/desktop/setup/install/mac-install/), then check:

<!-- rumdl-disable MD013 -->

```sh
docker version
docker compose version
```

<!-- rumdl-enable MD013 -->

Plan for 8 GB host RAM and 5 GB free storage as provisional allowances. An Intel source-environment runtime was
observed; Apple Silicon and novice package testing are pending.

<!-- rumdl-disable MD013 -->

```sh
cd '/path with spaces/assignment-1-package'
cp .env.example .env
docker compose pull
docker compose up -d --wait
docker compose ps
docker compose exec -T db psql -X -U student -d assignment1 -v ON_ERROR_STOP=1 -f /runtime/health.sql
```

<!-- rumdl-enable MD013 -->

Open `http://127.0.0.1:55050` (or `PGADMIN_PORT`), sign in with `.env`, and use **KSE Assignment 1**. Its internal
address is `db:5432`; host clients use `localhost` and the configured port. `psql` meta-commands do not run in
pgAdmin. Use the reset, transcript, and ZIP
commands in `assignment.md`; stop/restart with `docker compose stop` and `docker compose start`.

Create `submission/host-check.sql` with `SELECT 'saved' AS message;`, run
`docker compose exec -T db psql -X -U student -d assignment1 -f /submission/host-check.sql`, edit `saved` to
`edited`, save, and rerun, then begin editing `submission/`.
