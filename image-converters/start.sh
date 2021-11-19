#!/bin/bash

cd ${0%/*}

#CHECK: Are there any processes already running?
PIDLIST=`ps -fu grep -v grep | grep bulkpdf | awk '{print $2}'`
if [ ! -z ${PIDLIST} ]; then
  echo Processes already running - ${PIDLIST}
  exit 1
fi

# PIDLIST=`ps -fu grep -v grep | grep bulkpcl | awk '{print $2}'`
# if [ ! -z ${PIDLIST} ]; then
#   echo Processes already running - ${PIDLIST}
#   exit 1
# fi

echo Starting image-converters

nohup ./runbulkpcl.sh &
echo

