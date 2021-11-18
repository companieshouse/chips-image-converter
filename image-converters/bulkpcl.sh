#!/usr/sunos/bin/ksh

#if [ ! -d /tmp/ ]; then
#  mkdir /tmp/300dpi
#fi
#if [ ! -d /tmp/$1 ]; then
#  mkdir /tmp/$1
#fi
#if [ ! -d /tmp/$1/300dpi ]; then
#  mkdir /tmp/$1/300dpi
#fi

while [ 1 ]
do
NAME=efatt*$1.pcl
for FILE in ${NAME}
do
TIFFILE=temp${FILE%pcl}tif
FINALFILE=${FILE%pcl}tif
BADFILE=${FILE%pcl}failedtoconvert
BADFILE4QH=CSIBadPCL.tif

if [ ${#FILE} -gt 11 ];
then
        #/apps/bea/JetPcl/JetPcl -N -Y/tmp/$1 -P/tmp/$1 -S/tmp/$1 -IPCL -OTIF ${FILE} ${TIFFILE}
        #/apps/bea/JetPcl/JetPcl -N -d300 -IPCL -OTIF ${FILE} ${TIFFILE}
        ## worked but revised below for upgrade
		#/apps/bea/JetPcl/JetPcl -N -T/tmp/JetPcl -M/tmp/JetPcl -S/tmp/JetPcl -P/tmp/JetPcl -Y/tmp/JetPcl -d300 -Ipcl -Otif ${FILE} ${TIFFILE}
        /apps/bea/JetPcl/JetPcl -N -T/tmp/JetPcl -M/tmp/JetPcl/mac -S/tmp/JetPcl/sft -P/tmp/JetPcl/pat -Y/tmp/JetPcl/sym -d300 -Ipcl -Otif ${FILE} ${TIFFILE}
        
		EXITSTATUS=$?

        if [ ${EXITSTATUS} -eq 0 ];
        then
                BARCODE=`echo ${TIFFILE} | cut -c 10-17`
                SWAPTIFFILE="SWAPTIF${BARCODE}.tif"

                #Check the size of the tif - if 606 bytes then it is blank and we should consider it an error
                TIFFSIZE=`ls -l ${TIFFILE} | awk '{print $5}'`
                # Check we dont have too many pages and error if we do
                TOTALPAGES=` tiffinfo ${TIFFILE} | grep -c Page `

                #if [ ${TIFFSIZE} -eq 606 || ${TOTALPAGES} -gt 100 ];
                if (( ${TIFFSIZE} == 606 )) || (( ${TOTALPAGES} > 100 ));
                then
                   if [ -f ${SWAPTIFFILE} ];
                   then
                     mv ${SWAPTIFFILE} ${FINALFILE}
                   fi
                   mv ${FILE} ${BADFILE}
                else

                   if [ -f ${SWAPTIFFILE} ];
                   then
                     mv ${SWAPTIFFILE} ${TIFFILE}
                   fi

                   mv ${TIFFILE} ${FINALFILE}
                   # keep pcl files
                   mv ${FILE} ${FILE%pcl}okkept
                fi
        else
                ## If PCL is bad, copy warning image for QHers into place
                cp ${BADFILE4QH} ${FINALFILE}
                ## keep the BADFILE for now so we can check them if need be
                mv ${FILE} ${BADFILE}
                rm -f ${TIFFILE}
        fi
fi
done
sleep 2
done
