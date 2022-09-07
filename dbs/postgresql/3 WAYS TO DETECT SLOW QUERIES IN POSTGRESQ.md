 
 # 3 WAYS TO DETECT SLOW QUERIES IN POSTGRESQ
 
 ## Making use of the PostgreSQL slow query log
 If you want to turn the slow query log on globally, you can change postgresql.conf:

```conf
log_min_duration_statement = 5000
```

Also look for the following line, Make sure logging_collector is set to on.

```conf

logging_collector = on		# Enable capturing of stderr and csvlog
```

You will also find another variable in postgresql.conf, This indicates that PostgreSQL log file is located at /var/lib/pgsql/data/log/

```conf
log_directory = 'log'
```

If you change this line in postgresql.conf there is no need for a server restart. A “reload” will be enough:

```shell
postgres=# SELECT pg_reload_conf();
```

If you make the change only for a certain user or for a certain database:

```shell
postgres=# ALTER DATABASE test SET log_min_duration_statement = 5000;
```

ALTER DATABASE allows you to change the configuration parameter for a single database. Let us reconnect and run a slow query:

```shell
postgres=# \c test
You are now connected to database "test" as user "hs".
test=# SELECT pg_sleep(10);
pg_sleep
----------
 
(1 row)

```


A good way to do that is to run “explain analyze”,

## Checking unstable execution plans

The same applies to our next method. Sometimes your database is just fine but once in a while a query goes crazy. The goal is now to find those queries and fix them. One way to do that is to make use of the auto_explain module.

The idea is similar to what the slow query log does: Whenever something is slow, create log entries. In case of auto_explain you will find the complete execution plan in the logfile – not just the query. Why does it matter? Consider the following example:

```shell
test=# CREATE TABLE t_demo AS
          SELECT * FROM generate_series(1, 10000000) AS id;
SELECT 10000000
test=# CREATE INDEX idx_id ON t_demo (id);
CREATE INDEX
test=# ANALYZE;
ANALYZE
```

The table I have just created contains 10 million rows. In addition to that an index has been defined. Let us take a look at two almost identical queries:

```shell
test=# explain SELECT * FROM t_demo WHERE id < 10;
```

Finding a query, which takes too long for whatever reason is exactly when one can make use of auto_explain. Here is the idea: If a query exceeds a certain threshold, PostgreSQL can send the plan to the logfile for later inspection.

```shell
test=# LOAD 'auto_explain';
LOAD
test=# SET auto_explain.log_analyze TO on;
SET
test=# SET auto_explain.log_min_duration TO 500;
SET
```

The LOAD command will load the auto_explain module into a database connection.

For the demo we can do that easily. In a production system one would use postgresql.conf or ALTER DATABASE / ALTER TABLE to load the module. If you want to make the change in postgresql.conf, consider adding the following line to the config file:

```conf
session_preload_libraries = 'auto_explain';
```

session_preload_libraries will ensure that the module is loaded into every database connection by default. There is no need for the LOAD command anymore. Once the change has been made to the configuration (don’t forget to call pg_reload_conf() ) you can try to run the following query:

```shell
 test=# SELECT count(*) FROM t_demo GROUP BY id % 2;
  count
---------
 5000000
 5000000
(2 rows)
```

As you can see a full “explain analyze” will be sent to the logfile.

The advantage of this approach is that you can have a deep look at certain slow queries and see, when a queries decides on a bad plan. However, it is still hard to gather overall information because there might be millions of queries running on your system.

## Checking pg_stat_statements

The third method is to use pg_stat_statements. The idea behind pg_stat_statements is to group identical queries, which are just used with different parameters and aggregate runtime information in a system view.

To enable pg_stat_statements add the following line to postgresql.conf and restart your server:

```conf
shared_preload_libraries = 'pg_stat_statements'
```

Then run “CREATE EXTENSION pg_stat_statements” in your database. PostgreSQL will create a view for you:
```shell
test=# CREATE EXTENSION pg_stat_statements;
CREATE EXTENSION
test=# \d pg_stat_statements;
```



---

By the way

More log conf of postgres.conf to ref

```conf
# - Where to Log -

log_destination = 'stderr'              # Valid values are combinations of
                                        # stderr, csvlog, syslog, and eventlog,
                                        # depending on platform.  csvlog
                                        # requires logging_collector to be on.

# This is used when logging to stderr:
logging_collector = on          # Enable capturing of stderr and csvlog
                                        # into log files. Required to be on for
                                        # csvlogs.
                                        # (change requires restart)

# These are only used if logging_collector is on:
log_directory = 'log'                   # directory where log files are written,
                                        # can be absolute or relative to PGDATA
#log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log' # log file name pattern,
                                        # can include strftime() escapes
#log_file_mode = 0640                   # creation mode for log files,
                                        # begin with 0 to use octal notation
#log_rotation_age = 1d                  # Automatic rotation of logfiles will
                                        # happen after that time.  0 disables.
#log_rotation_size = 10MB               # Automatic rotation of logfiles will
                                        # happen after that much log output.
                                        # 0 disables.
#log_truncate_on_rotation = off         # If on, an existing log file with the
                                        # same name as the new log file will be
                                        # truncated rather than appended to.
                                        # But such truncation only occurs on
                                        # time-driven rotation, not on restarts
                                        # or size-driven rotation.  Default is
                                        # off, meaning append to existing files
                                        # in all cases.

# These are relevant when logging to syslog:
#syslog_facility = 'LOCAL0'
#syslog_ident = 'postgres'
#syslog_sequence_numbers = on
#syslog_split_messages = on

# This is only relevant when logging to eventlog (Windows):
# (change requires restart)
#event_source = 'PostgreSQL'

# - When to Log -

#log_min_messages = warning             # values in order of decreasing detail:
                                        #   debug5
                                        #   debug4
                                        #   debug3
                                        #   debug2
                                        #   debug1
                                        #   info
                                        #   notice
                                        #   warning
                                        #   error
                                        #   log
                                        #   fatal
                                        #   panic

#log_min_error_statement = error        # values in order of decreasing detail:
                                        #   debug5
                                        #   debug4
                                        #   debug3
                                        #   debug2
                                        #   debug1
                                        #   info
                                        #   notice
                                        #   warning
                                        #   error
                                        #   log
                                        #   fatal
                                        #   panic (effectively off)

#log_min_duration_statement = -1        # -1 is disabled, 0 logs all statements
                                        # and their durations, > 0 logs only
                                        # statements running at least this number
                                        # of milliseconds

#log_min_duration_sample = -1           # -1 is disabled, 0 logs a sample of statements
                                        # and their durations, > 0 logs only a sample of
                                        # statements running at least this number
                                        # of milliseconds;
                                        # sample fraction is determined by log_statement_sample_rate

#log_statement_sample_rate = 1.0        # fraction of logged statements exceeding
                                        # log_min_duration_sample to be logged;
                                        # 1.0 logs all such statements, 0.0 never logs


#log_transaction_sample_rate = 0.0      # fraction of transactions whose statements
                                        # are logged regardless of their duration; 1.0 logs all
                                        # statements from all transactions, 0.0 never logs

# - What to Log -

#debug_print_parse = off
#debug_print_rewritten = off
#debug_print_plan = off
#debug_pretty_print = on
#log_autovacuum_min_duration = -1       # log autovacuum activity;
                                        # -1 disables, 0 logs all actions and
                                        # their durations, > 0 logs only
                                        # actions running at least this number
                                        # of milliseconds.
#log_checkpoints = off
#log_connections = off
#log_disconnections = off
#log_duration = off
#log_error_verbosity = default          # terse, default, or verbose messages
#log_hostname = off
#log_line_prefix = '%m [%p] '           # special values:
                                        #   %a = application name
                                        #   %u = user name
                                        #   %d = database name
                                        #   %r = remote host and port
                                        #   %h = remote host
                                        #   %b = backend type
                                        #   %p = process ID
                                        #   %P = process ID of parallel group leader
                                        #   %t = timestamp without milliseconds
                                        #   %m = timestamp with milliseconds
                                        #   %n = timestamp with milliseconds (as a Unix epoch)
                                        #   %Q = query ID (0 if none or not computed)
                                        #   %i = command tag
                                        #   %e = SQL state
                                        #   %c = session ID
                                        #   %l = session line number
                                        #   %s = session start timestamp
                                        #   %v = virtual transaction ID
                                        #   %x = transaction ID (0 if none)
                                        #   %q = stop here in non-session
                                        #        processes
                                        #   %% = '%'
                                        # e.g. '<%u%%%d> '
#log_lock_waits = off                   # log lock waits >= deadlock_timeout
#log_recovery_conflict_waits = off      # log standby recovery conflict waits
                                        # >= deadlock_timeout
#log_parameter_max_length = -1          # when logging statements, limit logged
                                        # bind-parameter values to N bytes;
                                        # -1 means print in full, 0 disables
#log_parameter_max_length_on_error = 0  # when logging an error, limit logged
                                        # bind-parameter values to N bytes;
                                        # -1 means print in full, 0 disables
#log_statement = 'none'                 # none, ddl, mod, all

#log_replication_commands = off
#log_temp_files = -1                    # log temporary files equal or larger
                                        # than the specified size in kilobytes;
                                        # -1 disables, 0 logs all temp files
log_timezone = 'Etc/UTC'

```


