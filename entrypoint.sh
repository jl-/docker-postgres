#!/usr/bin/env bash
set -euo pipefail

# config files, lib path
PG_DATA_DIR=${PG_HOME_DIR}/${PG_MAJOR}/main
PG_BIN_DIR=/usr/lib/postgresql/${PG_MAJOR}/bin

function exec_as_postgres() {
    sudo -u postgres $@
}
function chown_to_postgres() {
    chown -R postgres:postgres $@
}

function boot() {
    # debug: remove existing cluster
    exec_as_postgres rm -rf ${PG_DATA_DIR}/*

    # initial db if not already
    if [ ! -s ${PG_DATA_DIR}/PG_VERSION ]; then
        # prepare dirs
        chown_to_postgres ${PG_HOME_DIR}
        exec_as_postgres mkdir -p ${PG_DATA_DIR}

        # initdb to ${PG_DATA_DIR}
        exec_as_postgres ${PG_BIN_DIR}/pg_ctl -D ${PG_DATA_DIR} initdb
    fi

    # resolve configs
    exec_as_postgres cp -f ${PG_HOME_DIR}/confs/*.conf ${PG_DATA_DIR}/

    exec_as_postgres ${PG_BIN_DIR}/pg_ctl -D ${PG_DATA_DIR} -w start
    if [ -d ${PG_HOME_DIR}/init.d ]; then
        cd ${PG_HOME_DIR}/init.d
        [ -f ./init.sh ] && exec_as_postgres bash ./init.sh
    fi
    exec_as_postgres ${PG_BIN_DIR}/pg_ctl -D ${PG_DATA_DIR} -w stop

    exec_as_postgres ${PG_BIN_DIR}/postgres -D ${PG_DATA_DIR}
}

boot
