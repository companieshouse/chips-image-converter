#!/bin/bash

# if [ ! -d /tmp/ ]; then
#   mkdir /tmp
# fi
# if [ ! -d /tmp/JetPcl ]; then
#   mkdir /tmp/JetPcl
#   mkdir /tmp/JetPcl/300dpi
#   mkdir /tmp/JetPcl/mac
#   mkdir /tmp/JetPcl/sft
#   mkdir /tmp/JetPcl/sft/300dpi
#   mkdir /tmp/JetPcl/pat
#   mkdir /tmp/JetPcl/pat/300dpi
#   mkdir /tmp/JetPcl/sym
#   cp /apps/bea/JetPcl/sft/300dpi/*.sft /tmp/JetPcl/sft/300dpi
# fi

for suffix in 0 1 2 3 4 5 6 7 8 9
do
   $1/bulkpdf.sh $suffix &
#sleep 2
#   $1/bulkpcl.sh $suffix &
done
