\x 0
\timing

\ir defs/types.sql;
\ir defs/tables.sql;

\ir routine/account/base.sql;

SELECT * FROM create_account('demo user');
SELECT * FROM accounts;

\dt
