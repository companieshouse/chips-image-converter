#!/bin/bash

cd ${ORACLE_HOME}/EFAttachments

while [ 1 ]
do
NAME=efatt*$1.pdf

for PDFFILE in ${NAME}
do
TIFFILE=temp${PDFFILE%pdf}tif
FINALFILE=${PDFFILE%pdf}tif
REPFILE=rep_"${PDFFILE}"
BADFILE=${PDFFILE%pdf}failedtoconvert
BADFILE4QH=${ORACLE_HOME}/CSIBadPDF.tif
BADFILE_MORE_PAGES=${PDFFILE%pdf}more_pages

tiffcreated() {
    #Check the size of the tif - if 606 bytes then it is blank and we should consider it an error
    TIFFSIZE=`ls -l ${TIFFILE} | awk '{print $5}'`
	# Check we dont have too many pages and error if we do
	TOTALPAGES=` tiffinfo ${TIFFILE} | grep -c Page `

	if (( ${TOTALPAGES} > 500 ));
    then
      mv ${PDFFILE} ${BADFILE_MORE_PAGES}
    elif (( ${TIFFSIZE} == 606 )) ;
    then
      mv ${PDFFILE} ${BADFILE}
    else
      mv ${TIFFILE} ${FINALFILE}
      # keep pdf files
      mv ${PDFFILE} ${PDFFILE%pdf}okkept
    fi
}

if [ ${#PDFFILE} -gt 11 ]; then
	BARCODE=`echo ${TIFFILE} | cut -c 10-17`
	SWAPTIFFILE="SWAPTIF${BARCODE}.tif"

	if [ -f ${SWAPTIFFILE} ]; then
		mv ${SWAPTIFFILE} ${FINALFILE}
	else
		${ORACLE_HOME}/${GS_MAIN_VERSION} -dPDFSTOPONERROR -dSHORTERRORS -dQUIET -dBATCH -dSAFER -dNOPAUSE -sCompression=g4 -sDEVICE=tiffscaled -r200 -sOutputFile=${TIFFILE} ${PDFFILE}
		EXITSTATUS=$?

		if (( ${EXITSTATUS} == 0 )) && [[ -f ${TIFFILE} ]];
		then
			tiffcreated
		else
			### Try to convert with an older version of ghostscript - the older version sometimes work for those that fail.
			##
			${ORACLE_HOME}/${GS_ALT_VERSION} -dPDFSTOPONERROR -dSHORTERRORS -dQUIET -dBATCH -dSAFER -dNOPAUSE -sCompression=g4 -sDEVICE=tiffscaled -r200 -sOutputFile=${TIFFILE} ${PDFFILE}
		  	EXITSTATUS=$?

			if (( ${EXITSTATUS} == 0 )) && [[ -f ${TIFFILE} ]];
			then
				tiffcreated
			else
				pdftocairo -pdf -r 300 "${PDFFILE}" "${REPFILE}" && ${ORACLE_HOME}/${GS_ALT_VERSION} -dNOPAUSE -q -r300x300 -sDEVICE=tiffg4 -dBATCH -sOutputFile="${TIFFILE}" "${REPFILE}"
				EXITSTATUS=$?
				rm -f "${REPFILE}"
				if (( ${EXITSTATUS} == 0 )); then
					tiffcreated
				else
					### If PDF conversion fails with non zero exit, copy warning image CSIBadPDF.tif for QHers into place
					##
					cp ${BADFILE4QH} ${FINALFILE}
					### keep the BADFILE for now so we can check them if need be
					##
					mv ${PDFFILE} ${BADFILE}
					rm -f ${TIFFILE}
					rm -f "${REPFILE}"
				fi
			fi
		fi
	fi
fi
done

### Remove old files
##
${ORACLE_HOME}/clean-old-files.sh $1
sleep 2 

### Move failed files to retry again
##
${ORACLE_HOME}/move-failed-files.sh $1
sleep 2 

done
