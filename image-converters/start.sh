#!/bin/bash

cd ${0%/*}

ENVNAME=${LOGNAME}

#CHECK: Are there any processes already running?
PIDLIST=`ps -fu ${ENVNAME} | grep -v grep | grep bulkpdf | awk '{print $2}'`
if [ ! -z ${PIDLIST} ]; then
  echo Processes already running - ${PIDLIST}
  exit 1
fi

# PIDLIST=`ps -fu ${ENVNAME} | grep -v grep | grep bulkpcl | awk '{print $2}'`
# if [ ! -z ${PIDLIST} ]; then
#   echo Processes already running - ${PIDLIST}
#   exit 1
# fi

CURRENTDIR=$PWD
DOMAINROOT=/apps/bea/${ENVNAME}/${ENVNAME}domain/${EFATTDIR}

cd ${DOMAINROOT}

echo Starting image-converters for ${ENVNAME}

nohup ${CURRENTDIR}/runbulkpcl.sh ${CURRENTDIR} &
echo

