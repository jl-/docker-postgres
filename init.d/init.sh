#!/usr/bin/env bash
set -euo pipefail

init_sql=./init.sql
cert_file=/run/secrets/db_cert

function read_cert_value () {
    local readonly b='[ \t]*'
    echo $(cat $cert_file | sed -n "s/^$b$1$b=$b\(.*\)$b$/\1/p")
}

dbname=$(read_cert_value dbname)
username=$(read_cert_value username)
password=$(read_cert_value password)

psql <<EOF
    -- create role
    DROP ROLE IF EXISTS $username;
    CREATE ROLE $username WITH LOGIN ENCRYPTED PASSWORD '$password';

    -- create database
    DROP DATABASE IF EXISTS $dbname;
    CREATE DATABASE $dbname WITH OWNER=$username ENCODING='UTF8';
    GRANT ALL ON DATABASE $dbname TO $username;

    -- connect to database
    \c $dbname $username;

    $(cat $init_sql)
EOF
