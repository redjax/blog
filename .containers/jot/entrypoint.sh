#!/bin/sh
set -eu

: "${JOT_PORT:=3210}"
: "${JOT_DATA_DIR:=/data}"

exec jot serve \
  --port "$JOT_PORT" \
  --data "$JOT_DATA_DIR"
