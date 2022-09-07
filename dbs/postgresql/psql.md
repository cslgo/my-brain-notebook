## psql commands 

```shell
# docker run -it --rm --network some-network postgres psql -h some-postgres -U postgres
docker run -it --rm postgres psql -h host.docker.internal -U postgres
# get help, as \h
postgres=# \help
# quit, as \q
postgres=# \quit
# reset user password, \q after enabled
postgres=# \password dlf
# Import the user.sql file into the exampled database
c:\>psql exampledb < user.sql
# Detailed display of the usage of the select command in the SQL command
postgres=# \h select
# show all databases
postgres=# \l
# Show all tables in the current database
postgres=# \dt
# Displays the table structure of the specified table in the current database
postgres=# \d [table_name]
# Display all schemas in the current database
postgres=# \dn
# Switch to the specified database, equivalent to use
postgres=# \c [database_name]
# show all users
postgres=# \du
# Display current database and connection information
postgres=# \conninfo
# Enter the Notepad sql script editing state (close after entering the batch command will be automatically executed in the command line)
postgres=# \e
# View index (to be associated)
postgres=# \di
# Prompt the user to set internal variables
postgres=# \prompt [text] name
# Display or set client character encoding
postgres=# \encoding [character encoding name]
# Import aaa.sql (to the current database)
postgres=# \i aaa.sql
# View all stored procedures (functions)
postgres=# \df
# View a stored procedure
postgres=# \df+ name
# ger pg version
postgres=# select version();
# get sys user info
postgres=# select usename from pg_user;
# drop user
postgres=# drop User 用户名
```

data dump

```shell
postgres=# \c test
test=# copy (select * from a.test) to '/tmp/a_test.txt'
test=# \! cat /tmp/a_test.txt
test=# copy a.test from '/tmp/a_test.txt'
test=# \copy a.test from '/tmp/a_test.txt'
test=# \copy (select * from a.test) to '/tmp/a_test.txt'
test=# \! cat /tmp/a_test.txt

copy (select * from myt) to '/tmp/myt.csv' with csv;
copy test to '/tmp/test.csv' with csv header;
copy (select * from test) to '/tmp/test.csv' with csv header;
copy (select foo, bar from baz) to '/tmp/query.csv' (format csv, delimiter ',');
\! head /tmp/test.csv
```


```txt
General
  \copyright             show PostgreSQL usage and distribution terms
  \g [FILE] or ;         execute query (and send results to file or |pipe)
  \h [NAME]              help on syntax of SQL commands, * for all commands
  \q                     quit psql

Query Buffer
  \e [FILE] [LINE]       edit the query buffer (or file) with external editor
  \ef [FUNCNAME [LINE]]  edit function definition with external editor
  \p                     show the contents of the query buffer
  \r                     reset (clear) the query buffer
  \s [FILE]              display history or save it to file
  \w FILE                write query buffer to file

Input/Output
  \copy ...              perform SQL COPY with data stream to the client host
  \echo [STRING]         write string to standard output
  \i FILE                execute commands from file
  \o [FILE]              send all query results to file or |pipe
  \qecho [STRING]        write string to query output stream (see \o)

Informational
  (options: S = show system objects, + = additional detail)
  \d[S+]                 list tables, views, and sequences
  \d[S+]  NAME           describe table, view, sequence, or index
  \da[S]  [PATTERN]      list aggregates
  \db[+]  [PATTERN]      list tablespaces
  \dc[S]  [PATTERN]      list conversions
  \dC     [PATTERN]      list casts
  \dd[S]  [PATTERN]      show comments on objects
  \ddp    [PATTERN]      list default privileges
  \dD[S]  [PATTERN]      list domains
  \det[+] [PATTERN]      list foreign tables
  \des[+] [PATTERN]      list foreign servers
  \deu[+] [PATTERN]      list user mappings
  \dew[+] [PATTERN]      list foreign-data wrappers
  \df[antw][S+] [PATRN]  list [only agg/normal/trigger/window] functions
  \dF[+]  [PATTERN]      list text search configurations
  \dFd[+] [PATTERN]      list text search dictionaries
  \dFp[+] [PATTERN]      list text search parsers
  \dFt[+] [PATTERN]      list text search templates
  \dg[+]  [PATTERN]      list roles
  \di[S+] [PATTERN]      list indexes
  \dl                    list large objects, same as \lo_list
  \dL[S+] [PATTERN]      list procedural languages
  \dn[S+] [PATTERN]      list schemas
  \do[S]  [PATTERN]      list operators
  \dO[S+] [PATTERN]      list collations
  \dp     [PATTERN]      list table, view, and sequence access privileges
  \drds [PATRN1 [PATRN2]] list per-database role settings
  \ds[S+] [PATTERN]      list sequences
  \dt[S+] [PATTERN]      list tables
  \dT[S+] [PATTERN]      list data types
  \du[+]  [PATTERN]      list roles
  \dv[S+] [PATTERN]      list views
  \dE[S+] [PATTERN]      list foreign tables
  \dx[+]  [PATTERN]      list extensions
  \l[+]                  list all databases
  \sf[+] FUNCNAME        show a function's definition
  \z      [PATTERN]      same as \dp

Formatting
  \a                     toggle between unaligned and aligned output mode
  \C [STRING]            set table title, or unset if none
  \f [STRING]            show or set field separator for unaligned query output
  \H                     toggle HTML output mode (currently off)
  \pset NAME [VALUE]     set table output option
                         (NAME := {format|border|expanded|fieldsep|footer|null|
                         numericlocale|recordsep|tuples_only|title|tableattr|pager})
  \t [on|off]            show only rows (currently off)
  \T [STRING]            set HTML <table> tag attributes, or unset if none
  \x [on|off]            toggle expanded output (currently off)

Connection
  \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
  \encoding [ENCODING]   show or set client encoding
  \password [USERNAME]   securely change the password for a user
  \conninfo              display information about current connection

Operating System
  \cd [DIR]              change the current working directory
  \timing [on|off]       toggle timing of commands (currently off)
  \! [COMMAND]           execute command in shell or start interactive shell

Variables
  \prompt [TEXT] NAME    prompt user to set internal variable
  \set [NAME [VALUE]]    set internal variable, or list all if no parameters
  \unset NAME            unset (delete) internal variable

Large Objects
  \lo_export LOBOID FILE
  \lo_import FILE [COMMENT]
  \lo_list
  \lo_unlink LOBOID      large object operations
```