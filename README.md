# KSE Assignment 1 package

This package contains the fictional KSE workshop scenario, data, local PostgreSQL/pgAdmin environment, and
prompt-only submission starter. Work from the folder containing `compose.yaml`. No repository URL or practice
environment is needed.

Start with [assignment.md](assignment.md), then [Windows](docs/setup-windows.md), [macOS](docs/setup-macos.md), or
[Linux](docs/setup-linux.md). See [troubleshooting](docs/troubleshooting.md).

Create `.env` once (`Copy-Item .env.example .env` in PowerShell or `cp .env.example .env` in a POSIX shell), then:

<!-- rumdl-disable MD013 -->

```sh
docker compose pull
docker compose up -d --wait
docker compose ps
docker compose exec -T db psql -X -U student -d assignment1 -v ON_ERROR_STOP=1 -f /runtime/health.sql
```

<!-- rumdl-enable MD013 -->

Your editable submission is `submission/`. Its files are `README.md`, `model.md`, `schema.sql`, `load.sql`,
`queries.sql`, `verification.sql`, and `evidence/verification.txt`. Do not edit package data or runtime files.

For a clean rebuild, this scoped reset recreates only `assignment1`, preserving host submission files and pgAdmin state:

<!-- rumdl-disable MD013 -->

```sh
docker compose exec -T db psql -X -U student -d postgres -v ON_ERROR_STOP=1 -v confirm_reset=assignment1 -f /runtime/reset.sql
```

<!-- rumdl-enable MD013 -->

Run your four SQL files through `/runtime/run.sql` and use the exact capture commands in `assignment.md`. Submit only
the completed `submission/` folder as a ZIP. The package has Compose references and bundled data; it does not
include image archives.
