# Windows setup

Use PowerShell. PostgreSQL, pgAdmin, and `psql` run in Docker; do not install host PostgreSQL or `psql`. Install
Docker Desktop, including its required WSL/virtualization setup, from the [official Windows
instructions](https://docs.docker.com/desktop/setup/install/windows-install/), start it, then check:

<!-- rumdl-disable MD013 -->

```powershell
docker version
docker compose version
```

<!-- rumdl-enable MD013 -->

Plan for 8 GB host RAM and 5 GB free storage as provisional course planning allowances, not measured requirements.
Native Windows, Windows ARM64, and novice testing are pending release checks.

From the package folder, quote paths containing spaces:

<!-- rumdl-disable MD013 -->

```powershell
Set-Location 'C:\Users\YourName\Documents\KSE Database Work\assignment-1-package'
Copy-Item .env.example .env
docker compose pull
docker compose up -d --wait
docker compose ps
docker compose exec -T db psql -X -U student -d assignment1 -v ON_ERROR_STOP=1 -f /runtime/health.sql
```

<!-- rumdl-enable MD013 -->

Open `http://127.0.0.1:55050` (or `PGADMIN_PORT`), sign in with `.env`, then use **KSE Assignment 1**. It connects
inside Compose to `db:5432`, database `assignment1`, user `student`; use `localhost` only for a host client.

In File Explorer enable **View → Show → File name extensions**: `.sql.txt` is not SQL. `psql` commands such as `\i`
run in container
`psql`, not pgAdmin Query Tool. Use the reset, transcript, and ZIP commands in `assignment.md` exactly; stop/restart
with `docker compose stop` and `docker compose start`.

Before starting the assignment, create UTF-8 `submission/host-check.sql` with `SELECT 'saved' AS message;`, run
`docker compose exec -T db psql -X -U student -d assignment1 -f /submission/host-check.sql`, change `saved`
to `edited`, save, and rerun. Then begin editing `submission/`.
