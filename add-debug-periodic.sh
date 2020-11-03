#!/bin/sh

mkdir -p /etc/periodic/debug
echo "*/1    *       *       *       *       run-parts /etc/periodic/debug" >> /var/spool/cron/crontabs/root