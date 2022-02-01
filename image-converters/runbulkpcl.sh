#!/bin/bash

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
