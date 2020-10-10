#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

source scripts/setenv.sh

#peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --isInit --tls $CORE_PEER_TLS_ENABLED --cafile ../test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n bigdatacc_0 -c '{"Args":["Init","b","[1.0,1.0,1.0]"]}' --waitForEvent

for (( i = 0; i < 1; ++i )) 
do
   peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED --cafile ../test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n bigdatacc_$1 -c '{"Args":["invoke","[\"a\",\"b\"]","c","0","50"]}' --waitForEvent
   echo "Welcome $i times for c init =  end =  chaincodeID = $1  "
done

#DELETE COMMAND
#peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED --cafile ../test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n bigdatacc_0 -c '{"Args":["delete","c"]}' --waitForEvent

peer chaincode query -C mychannel -n bigdatacc_$1 -c '{"Args":["query","c"]}'
