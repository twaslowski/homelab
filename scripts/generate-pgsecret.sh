#!/bin/bash
# Usage: ./generate-pgsecret.sh <password> <application-name> [--user USER] [--host HOST] [--port PORT] [--schema SCHEMA]

# Default values
USER=""
HOST=""
PORT=5432
SCHEMA=""

# Parse flags
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --user)
      USER="$2"
      shift 2
      ;;
    --host)
      HOST="$2"
      shift 2
      ;;
    --port)
      PORT="$2"
      shift 2
      ;;
    --schema)
      SCHEMA="$2"
      shift 2
      ;;
    *)
      # Positional args
      if [ -z "$PASSWORD" ]; then
        PASSWORD="$1"
      elif [ -z "$APP_NAME" ]; then
        APP_NAME="$1"
      else
        echo "Unknown argument: $1"
        exit 1
      fi
      shift
      ;;
  esac
done

if [ -z "$PASSWORD" ] || [ -z "$APP_NAME" ]; then
  echo "Usage: $0 <password> <application-name> [--user USER] [--host HOST] [--port PORT] [--schema SCHEMA]"
  exit 1
fi

# Set defaults if not overridden
[ -z "$USER" ] && USER="$APP_NAME"
[ -z "$HOST" ] && HOST="${APP_NAME}-pg-rw"
[ -z "$SCHEMA" ] && SCHEMA="$APP_NAME"

# Postgres DSN
PG_DSN="postgresql://${USER}:${PASSWORD}@${HOST}:${PORT}/${APP_NAME}"
# JDBC URI (set currentSchema)
JDBC_URI="jdbc:postgresql://${HOST}:${PORT}/${APP_NAME}?user=${USER}&password=${PASSWORD}&currentSchema=${SCHEMA}"

echo "Postgres DSN: $PG_DSN"
echo "JDBC URI:    $JDBC_URI"
