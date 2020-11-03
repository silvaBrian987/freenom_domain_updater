#!/bin/sh

APP_ARGS=""

if [ -n "$LOG_LEVEL" ]; then
    APP_ARGS="$APP_ARGS -v $LOG_LEVEL"
fi

APP_ARGS="$APP_ARGS -u $FREENOM_USERNAME -p $FREENOM_PASSWORD -d $FREENOM_DOMAINS"

python $HOME/app.py $APP_ARGS

if [ $? -ne 0 ]; then
    exit $?
fi
