\echo COUNTS BEFORE
-- Write six labelled clean-population count queries: participants, instructors, venues,
-- workshops, sessions, and registrations. Save the original value of a row that your
-- capacity demonstration will attempt to update.

\echo INTEGRITY DEMONSTRATIONS
-- Write three direct, otherwise-valid SQL operations using your own schema:
-- 1. INSERT an existing participant-session pair and inspect the uniqueness error.
-- 2. INSERT a row with a missing referenced identifier and inspect the foreign-key error.
-- 3. UPDATE a session to zero or negative capacity and inspect the CHECK error.
-- Do not use a function, a DO block, automatic error capture, or generated result labels.

\echo COUNTS AFTER
-- Repeat all six labelled counts and inspect the affected row after the attempted UPDATE.
