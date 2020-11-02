#!/bin/sh

if [ -n "$SCHEDULED" ]; then
    JOB_FILEPATH=/etc/periodic/15min/freenom_domain_updater_job
    echo '#!/bin/sh' > $JOB_FILEPATH
    echo "$HOME/run.sh" >> $JOB_FILEPATH
    chmod a+x $JOB_FILEPATH
    crond -l 2 -f
fi
