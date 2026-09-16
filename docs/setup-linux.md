# Linux setup

Use Terminal. Docker Desktop for Linux requirements and supported distributions change; check the [official Docker
Linux instructions](https://docs.docker.com/desktop/setup/install/linux/) and distribution-specific pages before
installation. Docker Desktop for Linux supports x86_64/amd64, not Linux arm64. Do not replace this with an untested
standalone engine; use a supported course machine if prerequisites, KVM, or architecture are unavailable.

After installing and starting Docker Desktop, check `docker version` and `docker compose version`. Plan for 8 GB host
RAM and 5 GB free storage as provisional allowances. Native Linux, ARM64, and novice testing are pending release
checks.

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

Use `http://127.0.0.1:55050` (or `.env`’s `PGADMIN_PORT`) and **KSE Assignment 1**. It uses `db:5432` internally;
host clients use `localhost`. `\i` and other `psql` commands do
not run in pgAdmin Query Tool. Use reset, transcript, and ZIP commands from `assignment.md`; stop/restart with
`docker compose stop` and `docker compose start`.

Create `submission/host-check.sql` with `SELECT 'saved' AS message;`, run
`docker compose exec -T db psql -X -U student -d assignment1 -f /submission/host-check.sql`, edit `saved` to
`edited`, save, and rerun, then begin editing `submission/`.
