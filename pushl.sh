#!/bin/bash

cd $(dirname "$0")
LOG=logs/pushl-$(date +%Y%m%d.log)

# redirect log output
if [ "$1" == "quiet" ] ; then
	exec >> $LOG 2>&1
else
	exec 2>&1 | tee -a $LOG
fi

# add timestamp
date

# run pushl
mkdir -p $HOME/var/pushl
flock -n $HOME/var/pushl/run.lock $HOME/.local/bin/pipenv run pushl \
    --max-connections 10 \
    -rvvkc $HOME/var/pushl \
    https://beesbuzz.biz/feed\?push=1 \
    https://publ.beesbuzz.biz/feed\?push=1 \
    https://novembeat.com/feed\?push=1 \
    http://beesbuzz.biz/feed \
    http://publ.beesbuzz.biz/feed \
    http://beesbuzz.biz/feed-summary https://beesbuzz.biz/feed-summary

# while we're at it, clean out the log and pushl cache directory
find logs $HOME/var/pushl -type f -mtime +30 -print -delete
