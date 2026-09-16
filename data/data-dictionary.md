# KSE workshop data dictionary

<!-- markdownlint-disable MD013 -->

This fictional KSE workshop dataset contains only synthetic identities and room labels. All release CSVs are UTF-8 without a BOM, comma-delimited, LF-terminated, and have a header on row 1. Fields containing commas, quotes, or line breaks must be CSV-quoted. Required fields may not be empty. `source_row=1` means the first data record after a header.

All identifiers are integer stable identifiers. `starts_at` is a UTC ISO-8601 timestamp (`YYYY-MM-DDTHH:MM:SSZ`). Participants have a required unique `email`; venues have a required unique `name`. Canonical workshop levels are `beginner`, `intermediate`, and `advanced`; raw casing must be normalized during loading.

| File and column | Meaning | Type | Required | Stable identifier / constraints |
| --- | --- | --- | --- | --- |
| participants.csv: `participant_id` | Synthetic student participant identifier | integer | yes | stable identifier; unique |
| participants.csv: `full_name` | Participant's synthetic full name | text | yes | — |
| participants.csv: `email` | Participant's synthetic email address | text | yes | unique |
| instructors.csv: `instructor_id` | Synthetic instructor identifier | integer | yes | stable identifier; unique |
| instructors.csv: `full_name` | Instructor's synthetic full name | text | yes | — |
| venues.csv: `venue_id` | Fictional KSE room identifier | integer | yes | stable identifier; unique |
| venues.csv: `name` | Fictional KSE room label | text | yes | unique |
| workshops.csv: `workshop_id` | Workshop topic identifier | integer | yes | stable identifier; unique |
| workshops.csv: `title` | Workshop title | text | yes | — |
| workshops.csv: `level` | Workshop difficulty label | text | yes | repair to a canonical level |
| sessions.csv: `session_id` | Scheduled workshop offering identifier | integer | yes | stable identifier; unique |
| sessions.csv: `workshop_id` | Referenced workshop identifier | integer | yes | references workshop data |
| sessions.csv: `instructor_id` | Referenced instructor identifier | integer | yes | references instructor data |
| sessions.csv: `venue_id` | Referenced venue identifier | integer | yes | references venue data |
| sessions.csv: `starts_at` | Scheduled UTC start instant | UTC ISO-8601 timestamp | yes | — |
| sessions.csv: `capacity` | Available places | integer | yes | must be positive to load |
| registrations.csv: `participant_id` | Referenced participant identifier | integer | yes | references participant data |
| registrations.csv: `session_id` | Referenced valid session identifier | integer | yes | pair is unique after loading |

Integrity treatment: retain the earliest duplicate registration source row; reject registrations with missing participant or valid-session references; reject sessions with zero or negative capacity. The raw files deliberately contain these issues for the assignment.
