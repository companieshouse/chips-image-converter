#!/bin/bash

# Move files that have been previously failed to convert and to retry after 20 minutes
for i in $(find efatt*$1.failedtoconvert -mmin +20)
do
  file_name=$(basename ${i} | cut -d. -f1)
  pdf_file_name="$file_name.pdf"
  echo "Moving ${i} to ${pdf_file_name}"
  mv ${i} ${pdf_file_name}
done


