#!/bin/bash
PIDLIST=`ps -ef | grep bulkpdf | grep -v grep | awk '{print $2}'`

for bulkpid in $PIDLIST
do

echo Killing $bulkpid
ps -ef | grep $bulkpid
kill $bulkpid

done

# On AWS stopping runbulkpcl will stop the container, so add to exclusion. Running this script will re-start processes.  
 PIDLIST=`ps -fu $LOGNAME | grep -v grep | grep -v runbulkpcl |grep bulkpcl | awk '{print $2}'`

 for bulkpid in $PIDLIST
 do

 echo Killing $bulkpid
 ps -ef | grep $bulkpid
 kill $bulkpid

 done
