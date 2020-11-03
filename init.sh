#!/bin/sh

$HOME/run.sh

if [ -n "$SCHEDULED" ]; then
    if [ -n "$SCHEDULED_DEBUG" ]; then
        echo "SCHEDULED DEBUG MODE"
        echo "Setting env to execute every minute..."
        JOB_FILEPATH=/etc/periodic/debug/freenom_domain_updater_job
    else
        echo "Setting env to execute every 15 minutes..."
        JOB_FILEPATH=/etc/periodic/15min/freenom_domain_updater_job
    fi
    echo '#!/bin/sh' > $JOB_FILEPATH
    echo "HOME=$HOME" >> $JOB_FILEPATH
    env | egrep '^FREENOM' | cat - $HOME/run.sh > temp && cat temp >> $JOB_FILEPATH
    chmod +x $JOB_FILEPATH
    # cat $JOB_FILEPATH
    echo "Starting crond..."
    crond -l 2 -f
fi
