# KSE workshop report contract

<!-- markdownlint-disable MD013 -->

All reports use cleaned data. All ID, count, and `capacity` columns are non-null integers; names, titles, levels, and
statuses are text; `starts_at` is a UTC timestamp; and `utilisation` is numeric. Only R3's `session_id` and `starts_at` may
be null. Use UTF-8 output headers, an empty field for null, ISO-8601 UTC timestamps, and a consistent numeric scale
for utilisation. Round utilisation to six decimal places.

| Report | Row grain and filter | Columns | Required order | Boundary contract |
|---|---|---|---|---|
| R1 | One qualifying session: canonical level `beginner` and `starts_at >= 2026-09-01T00:00:00Z` | `session_id,workshop_title,level,starts_at` | start, workshop title, session ID | Apply the inclusive filter and deterministic ordering. |
| R2 | One valid registration with its participant, workshop, session, and instructor | `session_id,participant_id,participant_name,workshop_title,instructor_name` | session ID, participant ID | Rejected registrations never appear. |
| R3 | One workshop-session combination, including an unscheduled workshop | `workshop_id,workshop_title,session_id,starts_at` | workshop ID, session ID `NULLS LAST` | Preserve the unmatched workshop with null session fields. |
| R4 | One session after counting valid registrations, retaining counts at least two | `session_id,registration_count` | session ID | Apply `HAVING` after counting. |
| R5 | One participant registered for a beginner or intermediate workshop | `participant_id,participant_name` | participant ID | Use `UNION` to eliminate overlap. |
| R6 | One session whose count exceeds the average registration count across valid sessions | `session_id,registration_count` | session ID | Include zero-registration sessions in the comparison population. |
| R7 | One valid session with venue and per-session registration/capacity ratio | `session_id,venue_name,registration_count,capacity,utilisation` | session ID | Use a CTE session summary, decimal division, and six-decimal rounding. |
| R8 | One valid session with a non-null count and capacity classification | `session_id,registration_count,status` | session ID | Use `CASE` and `COALESCE` for `empty`, `full`, or `available`. |

The scenario adds no status filter, term, prerequisite, or real KSE policy.
