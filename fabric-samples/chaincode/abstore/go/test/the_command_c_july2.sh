#!/bin/bash
for i in `seq 0 1`
do
   peer chaincode invoke -o orderer.example.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C $CHANNEL_NAME -n $CHANNEL_ID --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses peer0.org2.example.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"Args":["Set","c","AAAAAAAAAAAA"]}' --waitForEvent 
   echo "Welcome $i times for c"
   res=1
   while [ $res -gt 0 ]
   do
     peer chaincode query -C $CHANNEL_NAME -n $CHANNEL_ID -c '{"Args":["query","c"]}'
     res=$?
   done
done
