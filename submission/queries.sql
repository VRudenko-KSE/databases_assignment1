\echo R1
-- R1: upcoming beginner sessions; use the fixed inclusive timestamp and required ordering.

\echo R2
-- R2: valid registrations with participant, workshop, session, and instructor details.

\echo R3
-- R3: workshops and their sessions, retaining workshops without sessions.

\echo R4
-- R4: per-session registration counts of at least two; use HAVING.

\echo R5
-- R5: participants in the beginner or intermediate populations; use UNION.

\echo R6
-- R6: sessions above the average count across all valid sessions; use a subquery.

\echo R7
-- R7: per-session utilisation at its venue; use a CTE and decimal division.

\echo R8
-- R8: non-null counts and empty/full/available status; use CASE and COALESCE.
