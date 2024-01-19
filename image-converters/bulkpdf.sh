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

tiffcreated() {
    #Check the size of the tif - if 606 bytes then it is blank and we should consider it an error
    TIFFSIZE=`ls -l ${TIFFILE} | awk '{print $5}'`
    # Check we dont have too many pages and error if we do
	TOTALPAGES=` tiffinfo ${TIFFILE} | grep -c Page `

    if (( ${TIFFSIZE} == 606 )) || (( ${TOTALPAGES} > 500 ));
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

		if (( ${EXITSTATUS} == 0 )) && [[ -f ${TIFFILE} ]]; then
			tiffcreated
		elif [ "${EXITSTATUS}" != 0 ]; then
			### Try to convert with an older version of ghostscript - the older version sometimes work for those that fail.
			##
			${ORACLE_HOME}/${GS_ALT_VERSION} -dPDFSTOPONERROR -dSHORTERRORS -dQUIET -dBATCH -dSAFER -dNOPAUSE -sCompression=g4 -sDEVICE=tiffscaled -r200 -sOutputFile=${TIFFILE} ${PDFFILE}
		  	EXITSTATUS=$?

			if (( ${EXITSTATUS} == 0 )) && [[ -f ${TIFFILE} ]]; then
				 tiffcreated
			### another check added -- razielj
			##
			elif [ "${EXITSTATUS}" != 0 ]; then
				pdftocairo -pdf -r 300 "${PDFFILE}" "${REPFILE}" && gs -dNOPAUSE -q -r300x300 -sDEVICE=tiffg4 -dBATCH -sOutputFile="${TIFFILE}" "${REPFILE}"
				rm -f "${REPFILE}"
				EXITSTATUS=$?
				elif [ "${EXITSTATUS}" == 0 ]; then
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
done

### Remove old files
##
${ORACLE_HOME}/clean-old-files.sh $1
sleep 2 
done
