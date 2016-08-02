#!/bin/sh
# Usage:
# pre-commit     make sure to have an heroku remote in yoru git config
#                then execute

# Debug
set -x

$HEROKU_APP_NAME="resa-liberte-paris"

echo "Push to heroku"
git push heroku master:master

echo "Run migration"
heroku run rake db:migrate -a $HEROKU_APP_NAME

echo "Restart"
heroku restart -a $HEROKU_APP_NAME
