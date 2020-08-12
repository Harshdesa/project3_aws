#!/bin/bash
for i in `seq 2 5`
do
   sh contractSetupScript.sh $i
   echo "Contract $i Set UP"
   res=1
   #while [ $res -gt 0 ]
   #do
   #  export CHANNEL_NAME=mychannel
   #  export CHANNEL_ID=mycc_$i
   #  peer chaincode query -C $CHANNEL_NAME -n $CHANNEL_ID -c '{"Args":["query","a"]}'
   #  res=$?
   #done
done
