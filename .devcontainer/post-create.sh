#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

pipenv install --dev

if [[ ! -f secrets.env ]]; then
  ./set-secrets.sh
fi

set -o allexport; source .env; set +o allexport
COMPOSE="$COMPOSE -f docker-compose.yml -f docker-compose.debug.yml"
# shellcheck disable=SC1091
. ./secrets.env
$COMPOSE up opa db mqtt openldap -d

echo "Setup done. Run ./debug.sh (or ./debug-manage.sh <args>) to start the Django dev server."
