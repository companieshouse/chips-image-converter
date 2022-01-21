#!/bin/bash

# writing to JetPcl dir rather then tmp now 
#  if [ ! -d /tmp/ ]; then
#    mkdir /tmp
#  fi
#  if [ ! -d /tmp/JetPcl ]; then
#    mkdir /tmp/JetPcl
#    mkdir /tmp/JetPcl/300dpi
#    mkdir /tmp/JetPcl/mac
#    mkdir /tmp/JetPcl/sft
#    mkdir /tmp/JetPcl/sft/300dpi
#    mkdir /tmp/JetPcl/pat
#    mkdir /tmp/JetPcl/pat/300dpi
#    mkdir /tmp/JetPcl/sym
#    cp /apps/oracle/JetPcl/sft/300dpi/*.sft /tmp/JetPcl/sft/300dpi
#  fi

# place wait in loop as AWS contanier will exit if wait ends (stop script) 
while :
do
   for suffix in 0 1 2 3 4 5 6 7 8 9
   do
     ./bulkpdf.sh $suffix &
     sleep 2
     ./bulkpcl.sh $suffix &
   done
   wait
done