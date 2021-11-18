#!/bin/bash
PIDLIST=`ps -fu $LOGNAME | grep -v grep | grep bulkpdf | awk '{print $2}'`

for bulkpid in $PIDLIST
do

echo Killing $bulkpid
ps -ef | grep $bulkpid
kill $bulkpid

done

# PIDLIST=`ps -fu $LOGNAME | grep -v grep | grep bulkpcl | awk '{print $2}'`

# for bulkpid in $PIDLIST
# do

# echo Killing $bulkpid
# ps -ef | grep $bulkpid
# kill $bulkpid

# done
