#!/bin/bash
for i in `seq 2 7`
do
   echo "Welcome $i times"
   res=1
   while [ $res -gt 0 ] 
   do  
     echo "hello"
     res=$?
     echo $res
   done
done
