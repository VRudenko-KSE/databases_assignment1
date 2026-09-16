# Assignment 1: From Messy Data to a Trustworthy Database

This individual assignment is worth **15 points**. It opens at Lecture 1 / Week 1 and is completed independently on
your laptop.

## Scenario

For this assignment, imagine that **KSE (Kyiv School of Economics)** is organising short academic and
professional-skills workshops for its students. Topics include data analysis, economics, research methods, and
academic writing. A workshop can run in several scheduled sessions, each with an instructor, a room, and a limited
number of places.

The coordinator has CSV exports for student participants, instructors, rooms, workshops, sessions, and registrations.
Combining and editing the exports introduced duplicate registrations, missing references, inconsistent workshop-level
labels, and invalid session capacities. Design a small PostgreSQL database, load it reproducibly with documented
repairs or rejections, enforce the rules, and produce eight reports. Your files must let a TA rebuild and inspect the
database during a practical session.

This is a fictional teaching scenario at KSE. All people, rooms, and registrations are synthetic; it is not an actual
KSE administrative system.

Use six entities: participants (stable ID; unique email), instructors (stable ID), rooms (stable ID; unique name),
workshops (stable ID, title, one canonical level), sessions (one workshop, instructor, room, positive capacity), and
registrations (one participant and one session, unique as a pair). The three canonical levels are `beginner`,
`intermediate`, and `advanced`. Do not invent missing participant, session, workshop, instructor, or room records
merely to load bad input.

## Supplied package and data contract

Work in the provided `assignment-1-package/` folder containing `compose.yaml`. Commands run locally; no registration
API, repository URL, or `assignment-1` profile is required. Read `data/data-dictionary.md` and
`data/report-contract.md`.

The supplied inputs are `data/participants.csv`, `data/instructors.csv`, `data/venues.csv`,
`data/workshops.csv`, `data/sessions.csv`, and `data/registrations.csv`. Apply the documented business rules: repair
workshop-level representation to the canonical levels; accept only positive-capacity sessions; retain only
registrations whose referenced participant and session are valid; and enforce one registration per participant-session
pair. Retain the earliest physical source row when duplicate registrations compete. Identify and classify every
affected source row or stable identifier yourself. CSVs are UTF-8; preserve quoting and do not edit supplied files.

## Required work

Complete all work yourself. You may discuss concepts, practise exercises, and ask peers to review an error message,
but do not share or copy submission files, finished queries, diagrams, or captured evidence.

Create `model.md` with an ER diagram, relationships, keys, cardinalities, constraints, repair/rejection decisions,
one removed anomaly, and one deliberate trade-off. In `schema.sql`, create a lightly normalised schema using primary
keys, foreign keys, `UNIQUE`, `NOT NULL`, and justified `CHECK` constraints; do not use names, titles, or row order
as keys. In `load.sql`, use reproducible SQL and `psql` to load unchanged files from `/data`, load all valid facts,
and document every repair or rejection. Do not disable integrity rules or silently drop bad input.

In `queries.sql`, implement exactly eight labelled reports as defined by `data/report-contract.md`:

- **R1:** one row per upcoming `beginner` session; `starts_at >= 2026-09-01T00:00:00Z` is inclusive. Order by start,
  workshop title, then session identifier.
- **R2:** one row per valid registration with participant, workshop, session, and instructor details.
- **R3:** one row per workshop-session combination, retaining workshops without sessions.
- **R4:** per-session registration counts of at least two, using `HAVING`.
- **R5:** participants registered for beginner workshops or intermediate workshops, using `UNION`; these are the two
  populations and a person in both appears once.
- **R6:** sessions above the average registration count across all valid sessions, including zero-registration
  sessions, using a subquery.
- **R7:** one row per session, showing room utilisation as confirmed registrations divided by positive capacity. Use a
  CTE, decimal division, and round utilisation to six decimal places; zero registrations gives zero.
- **R8:** every session, a non-null registration count, and `empty`, `full`, or `available` status using `CASE` and
  `COALESCE`.

In `verification.sql`, show six labelled clean-population counts, then use three direct SQL demonstrations: an
existing participant-session pair, a missing reference, and a non-positive capacity. Inspect the exact PostgreSQL
error and constraint for each, then repeat the counts and inspect the affected value. Capture your four-file replay
in `evidence/verification.txt`; the intentional errors remain visible so the final process exit code alone is not
proof that the demonstrations were correct.

## Environment and clean replay

Run commands from the supplied Assignment 1 folder containing `compose.yaml`. Create `.env` once; do not overwrite one
that exists:

<!-- rumdl-disable MD013 -->

```powershell
Copy-Item .env.example .env
```

<!-- rumdl-enable MD013 -->

<!-- rumdl-disable MD013 -->

```sh
cp .env.example .env
```

<!-- rumdl-enable MD013 -->

<!-- rumdl-disable MD013 -->

```sh
docker compose pull
docker compose up -d --wait
docker compose ps
docker compose exec -T db psql -X -U student -d assignment1 -v ON_ERROR_STOP=1 -f /runtime/health.sql
```

<!-- rumdl-enable MD013 -->

pgAdmin is at `http://127.0.0.1:55050` by default. Its preloaded **KSE Assignment 1** registration uses `db:5432`,
database `assignment1`, and user `student`; `localhost` and the configured host port are for a host client. `psql`
and `\i` commands run through container `psql`, not pgAdmin Query Tool. See the OS guide for installation, save/edit
rehearsal, UTF-8, and paths containing spaces.

Before a deliberate clean rebuild, close connections to `assignment1`. This recreates only the marked assignment
database; it preserves host submission files, pgAdmin state, and practice work:

<!-- rumdl-disable MD013 -->

```sh
docker compose exec -T db psql -X -U student -d postgres -v ON_ERROR_STOP=1 -v confirm_reset=assignment1 -f /runtime/reset.sql
```

<!-- rumdl-enable MD013 -->

Run `schema.sql`, `load.sql`, `queries.sql`, then `verification.sql`. Capture actual output. PowerShell:

<!-- rumdl-disable MD013 -->

```powershell
docker compose exec -T db psql -X -a -U student -d assignment1 -v ON_ERROR_STOP=1 -f /runtime/run.sql 2>&1 |
    Tee-Object -FilePath ./submission/evidence/verification.txt
$assignmentRunExit = $LASTEXITCODE
Write-Output "psql exit code: $assignmentRunExit"
```

<!-- rumdl-enable MD013 -->

macOS/Linux Bash:

<!-- rumdl-disable MD013 -->

```bash
set -o pipefail
docker compose exec -T db psql -X -a -U student -d assignment1 -v ON_ERROR_STOP=1 -f /runtime/run.sql 2>&1 |
  tee submission/evidence/verification.txt
assignment_run_exit=$?
printf 'Replay pipeline exit code: %s\n' "$assignment_run_exit"
```

<!-- rumdl-enable MD013 -->

The transcript is intentionally replaced by the selected clean run; keep earlier attempts elsewhere if wanted.
Inspect both output and exit status. If PowerShell’s default output is not UTF-8, export as UTF-8.

## Required submission and practice verification

Submit only `submission/` containing `README.md`, `model.md`, `schema.sql`, `load.sql`, `queries.sql`,
`verification.sql`, and `evidence/verification.txt` (an optional `assets/` directory may contain a non-Mermaid
diagram). Package it after inspecting its single root. PowerShell:

<!-- rumdl-disable MD013 -->

```powershell
Compress-Archive -Path ./submission -DestinationPath ./assignment-1.zip
```

<!-- rumdl-enable MD013 -->

macOS/Linux, from the package root:

<!-- rumdl-disable MD013 -->

```sh
zip -r assignment-1.zip submission
```

<!-- rumdl-enable MD013 -->

Create a new archive or explicitly replace a prior archive after inspecting it; do not append stale files. Exclude
raw data, runtime files, experiments, old attempts, and container images. Submit one ZIP to the Moodle activity named
in the release announcement. Moodle’s recorded submission time is authoritative; the announcement provides
activity, size limit, support route, and feedback location. A TA manually replays the submitted version during a
scheduled practice, checks all reports and integrity demonstrations, and records unobserved checks separately.

## Assessment and defence

This assignment is **15 points**: technical correctness /6 (schema and constraints /3, loading /1, reports /2) and
assignment defence /9. Defence is two published questions /4 plus discussion of your submitted work /5 (understanding
/2, evidence interpretation /2, trade-offs/changes /1). A written answer does not replace your independent oral
answer.

Each selected bank item is worth 2 points: 1 point per short question. You may use equivalent terminology or a
justified schema; the questions assess explanation and reasoning, not a memorised full SQL query.

<!-- rumdl-disable MD013 -->

1. What does a DBMS provide beyond ordinary files? Why is SQL called declarative?
2. What is the difference between selection and projection? Why should `ORDER BY` include a tie-breaker when used with `LIMIT`?
3. What does a primary key guarantee? Why should a mutable name not be used as a primary key?
4. What does a foreign key guarantee? Why should parent rows be loaded before dependent rows?
5. How is a many-to-many relationship represented? What is database normalization?
6. What is the difference between `UNIQUE` and `NOT NULL`? What does a `CHECK` constraint do?
7. What is the difference between `INNER JOIN` and `LEFT JOIN`? What is the difference between `COUNT(*)` and `COUNT(column)`?
8. What do `GROUP BY` columns determine? What is the difference between `WHERE` and `HAVING`?
9. What is the difference between `UNION` and `UNION ALL`? What must be true for results to be combined with `UNION`?
10. What is the difference between a CTE and a subquery? Why divide a complex query into intermediate results?

<!-- rumdl-enable MD013 -->

## Submission, individual work, and manual review

Complete all work yourself. You may discuss concepts, practise exercises, and ask peers to review an error message,
but do not share or copy submission files, finished queries, diagrams, or captured evidence. Reuse a query from a
named practice only when course staff explicitly designate it as shared starter material; adapt, verify, and explain
it independently.

Submit one ZIP to the Moodle activity named in the release announcement. Its root is `submission/`; Moodle's
recorded submission time is authoritative. A replacement uploaded before the applicable cutoff supersedes the earlier
archive. Ordinary replacement closes after the cutoff unless an approved institutional exception applies.

A TA manually reviews the submitted version in a scheduled practical: from an empty assignment database and unchanged
supplied data, they run schema, load, and reports with strict error stopping, then run verification with intentional
errors visible so later checks continue. The TA checks counts, each R1–R8 report against the contract, all three
intended integrity failures and unchanged state, the transcript, model rationale, anomaly, and trade-off. Missing
evidence and unobserved checks are recorded separately; one root error does not erase unrelated credit. An unavailable
database, damaged supplied dataset, or environment failure is recorded separately from student correctness, and
unobserved work is handled under published arrangements. The TA keeps a separate verification record.

The TA selects two distinct defence-bank questions. You may consult submitted files but must answer independently,
without live assistance. There is no separate defence pass threshold. A submission awaiting defence has a provisional
technical score. A staff-scheduled defence after the deadline does not make an on-time submission late; published
missed-defence and make-up arrangements apply. The TA records selected question numbers and reasons for awarded
points, and assesses understanding rather than presentation polish. After published missed-defence arrangements are
exhausted, unanswered components earn zero. The late cap applies to the combined technical-correctness and defence
total.

Full credit is available until the published timestamp immediately before Practice 8 / Week 4, at least seven
calendar days after Practice 6. The late period ends seven calendar days later in Week 5 and caps the possible mark
at 7.5/15. After that cutoff the mark is zero unless an approved institutional exception applies. Exact Europe/Kyiv
timestamps, Moodle activity, defence slots, permitted materials, and missed-defence arrangements remain release
information and are not yet published.

The current course academic-integrity and AI-tools policy applies without modification. You may use permitted support
only as that policy allows; do not ask a tool to produce the schema, queries, model, or complete assignment. When
disclosure is required, include `AI_DISCLOSURE.md` with the tool, date, original prompt, affected material, and how
you checked and revised it.

After all required work, you may add a clearly marked non-assessed note in `model.md` proposing one future rule such
as a waiting list. Do not change the required schema, files, or evidence tree.
