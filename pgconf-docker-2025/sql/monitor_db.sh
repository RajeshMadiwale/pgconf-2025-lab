#!/bin/bash

export pgdb="$1"
# System monitoring function
monitor_system() {
    echo "=== System CPU Usage ==="
    mpstat 1 1

    echo -e "\n=== Top CPU Processes ==="
    ps aux --sort=-%cpu | head -5

    echo -e "\n=== I/O Statistics ==="
    iostat -xz 1 1

    echo -e "\n=== Memory Usage ==="
    free -m
}

# PostgreSQL monitoring function
monitor_postgres() {
    cho -e "\n=== PostgreSQL Statistics ==="
    psql -d $pgdb -c "
    SELECT pid, usename,left(query,20), state,
           extract(epoch from now() - query_start) as duration
    FROM pg_stat_activity
    WHERE state != 'idle'
    ORDER BY duration DESC
    LIMIT 5;"

    echo -e "\n=== PostgreSQL I/O Stats ==="
    psql -d $pgdb -c "
    SELECT schemaname, relname, heap_blks_read, heap_blks_hit,
           idx_blks_read, idx_blks_hit
    FROM pg_statio_user_tables
    ORDER BY heap_blks_read + idx_blks_read DESC
    LIMIT 5;"

    echo -e "\n == Get blocked sessions count == "

    psql -d $pgdb -c  " SELECT blocked_activity.pid AS blocked_pid,
                        blocked_activity.query AS blocked_query,
                        blocking_activity.pid AS blocking_pid,
                        blocking_activity.query AS blocking_query
                    FROM pg_stat_activity blocked_activity
                    JOIN pg_stat_activity blocking_activity
                        ON blocking_activity.pid = ANY(pg_blocking_pids(blocked_activity.pid))
                    WHERE blocked_activity.datname = '$pgdb';"
}

# Main monitoring loop
while true; do
    clear
    date
    monitor_system
    monitor_postgres
    sleep 5
done