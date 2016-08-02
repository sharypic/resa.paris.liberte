#!/bin/sh
# Usage:
# pre-commit     make sure to have an heroku remote in yoru git config
#                then execute

set -x

git push heroku master:master
