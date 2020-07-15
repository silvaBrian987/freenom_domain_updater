APP_ARGS=""

if [ -n "$LOG_LEVEL" ]
then
    APP_ARGS="$APP_ARGS -v $LOG_LEVEL"
fi

APP_ARGS="$APP_ARGS -u $FREENOM_USERNAME -p $FREENOM_PASSWORD -d $FREENOM_DOMAINS"

if [ -n "$SCHEDULED" ]
then
    python ./app.py $APP_ARGS
    echo "#!/bin/sh" > /etc/periodic/15min/freenom_domain_updater_job
    echo "python ./app.py $APP_ARGS" >> /etc/periodic/15min/freenom_domain_updater_job
    chmod a+x /etc/periodic/15min/freenom_domain_updater_job
    crond -l 2 -f
else
    python ./app.py $APP_ARGS
fi
