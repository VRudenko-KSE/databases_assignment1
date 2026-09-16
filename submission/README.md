# Assignment 1 submission

Complete your own work in this directory. The required replay order is:

1. `schema.sql` — create your schema and constraints.
2. `load.sql` — reproducibly load and classify the supplied data.
3. `queries.sql` — produce R1–R8.
4. `verification.sql` — show counts and integrity demonstrations.

`model.md` explains your ER design, input decisions, anomaly, and trade-off. `evidence/verification.txt` is the
captured output from your own clean replay. Add the names of your model's tables here: **[replace with your table
names]**.

A TA reproduces this submission by resetting `assignment1` from the supplied Assignment 1 folder, then running
`/runtime/run.sql`; it includes the four files above in that order. Run it and capture the transcript:

<!-- rumdl-disable MD013 -->

```sh
docker compose exec -T db psql -X -a -U student -d assignment1 -v ON_ERROR_STOP=1 -f /runtime/run.sql
```

<!-- rumdl-enable MD013 -->

Use the full PowerShell or Bash transcript commands in `assignment.md`. Your schema and load scripts run through
container `psql`; pgAdmin Query Tool is useful for exploration but does not run `psql` meta-commands such as `\i`.

## Configuration, replay, and packaging

Create `.env` once; do not overwrite an existing `.env`.

PowerShell configuration:

```powershell
Copy-Item .env.example .env
```

macOS/Linux configuration:

```sh
cp .env.example .env
```

All shells: pull, start, and check health:

```sh
docker compose pull
docker compose up -d --wait
docker compose ps
docker compose exec -T db psql -X -U student -d assignment1 -v ON_ERROR_STOP=1 -f /runtime/health.sql
```

When ready for a clean rebuild, reset only `assignment1`; host submission files and pgAdmin state remain:

<!-- rumdl-disable MD013 -->

```sh
docker compose exec -T db psql -X -U student -d postgres -v ON_ERROR_STOP=1 -v confirm_reset=assignment1 -f /runtime/reset.sql
```

<!-- rumdl-enable MD013 -->

PowerShell transcript:

```powershell
docker compose exec -T db psql -X -a -U student -d assignment1 -v ON_ERROR_STOP=1 -f /runtime/run.sql 2>&1 |
    Tee-Object -FilePath ./submission/evidence/verification.txt
$assignmentRunExit = $LASTEXITCODE
Write-Output "psql exit code: $assignmentRunExit"
```

Bash transcript:

```bash
set -o pipefail
docker compose exec -T db psql -X -a -U student -d assignment1 -v ON_ERROR_STOP=1 -f /runtime/run.sql 2>&1 |
  tee submission/evidence/verification.txt
assignment_run_exit=$?
printf 'Replay pipeline exit code: %s\n' "$assignment_run_exit"
```

PowerShell ZIP:

```powershell
Compress-Archive -Path ./submission -DestinationPath ./assignment-1.zip
```

macOS/Linux ZIP (run from the package root):

```sh
zip -r assignment-1.zip submission
```
