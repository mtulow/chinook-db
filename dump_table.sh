#!/bin/bash
DB_NAME=$1
TABLE_NAME=$2

sqlite3 << EOF
.open "$DB_NAME"
.output "$TABLE_NAME.sql"
.dump "$TABLE_NAME"
.exit
EOF