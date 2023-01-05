#!/bin/bash

# Remove files that have been previously created that are older than 1 day
find efatt*$1.okkept -mtime +1 -exec rm {} \;  2>/dev/null
find efatt*$1.tif -mtime +1 -exec rm {} \; 2>/dev/null
find efatt*$1.failedtoconvert -mtime +1 -exec rm {} \; 2>/dev/null

