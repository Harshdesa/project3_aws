if [ -z "$1" ]
  then
    echo "chaincode identifier argument supplied"
    exit 1
fi

cd /opt/gopath/src/github.com/hyperledger/fabric-samples/chaincode/abstore/go 
pwd
export GO111MODULE=on go mod vendor

export TAR_GZ=test.tar.gz 
export LABELL=mycc_$1
echo $TAR_GZ

cd /opt/gopath/src 

echo "Packaging chaincode"
res=1
while [ $res -gt 0 ]
do
  peer lifecycle chaincode package $TAR_GZ --path github.com/hyperledger/fabric-samples/chaincode/abstore/go/ --lang golang --label $LABELL 
  res=$?
done

echo "Installing chaincode"
res=1                                                                                                                                    
while [ $res -gt 0 ]                                                                                                                          
do
  peer lifecycle chaincode install $TAR_GZ
  res=$?                                
done

peer lifecycle chaincode queryinstalled | grep $LABELL > installed_chaincode.txt

export CC_PACKAGE_ID=$(cat installed_chaincode.txt | cut -d' ' -f3 | cut -d',' -f1)
export CHANNEL_NAME=mychannel 
export CHANNEL_ID=mycc_$1
echo $CC_PACKAGE_ID


export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp 
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051 
export CORE_PEER_LOCALMSPID="Org2MSP" 
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt 


echo "Installing chaincode on org2"
res=1                      
while [ $res -gt 0 ]                                                                                                                       
do                         
  peer lifecycle chaincode install $TAR_GZ
  res=$?                                  
done


echo "approve for org2"
res=1                      
while [ $res -gt 0 ]
do
  peer lifecycle chaincode approveformyorg --channelID $CHANNEL_NAME --name $CHANNEL_ID --version 1.0 --init-required --package-id $CC_PACKAGE_ID --sequence 1 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
  res=$?
done

echo "check for commit readiness"
res=1
while [ $res -gt 0 ]
do
  peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name $CHANNEL_ID --version 1.0 --init-required --sequence 1 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --output json
  res=$?
done


export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp 
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051 
export CORE_PEER_LOCALMSPID="Org1MSP" 
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt 


echo "Installing chaincode on org1"
res=1
while [ $res -gt 0 ]
do
  peer lifecycle chaincode install $TAR_GZ
  res=$?
done

echo "approve for org1"
res=1
while [ $res -gt 0 ]
do
  peer lifecycle chaincode approveformyorg --channelID $CHANNEL_NAME --name $CHANNEL_ID --version 1.0 --init-required --package-id $CC_PACKAGE_ID --sequence 1 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
  res=$?
done


echo "check for commit readiness"
res=1
while [ $res -gt 0 ]
do
  peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name $CHANNEL_ID --version 1.0 --init-required --sequence 1 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --output json
  res=$?
done


echo "commit"
res=1
while [ $res -gt 0 ]
do
  peer lifecycle chaincode commit -o orderer.example.com:7050 --channelID $CHANNEL_NAME --name $CHANNEL_ID --version 1.0 --sequence 1 --init-required --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses peer0.org2.example.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt 
  res=$?
done

echo "Init with data"
res=1
while [ $res -gt 0 ]
do
  peer chaincode invoke -o orderer.example.com:7050 --isInit --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C $CHANNEL_NAME -n $CHANNEL_ID --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses peer0.org2.example.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"Args":["Init","a","////////////"]}' --waitForEvent 
  res=$?
done

echo "Query the data"
res=1
while [ $res -gt 0 ]
do
  peer chaincode query -C $CHANNEL_NAME -n $CHANNEL_ID -c '{"Args":["query","a"]}'
  res=$?
done
