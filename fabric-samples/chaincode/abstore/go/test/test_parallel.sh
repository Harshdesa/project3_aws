#docker exec cli sh /opt/gopath/src/github.com/hyperledger/fabric-samples/chaincode/abstore/go/test/the_command_a.sh &

export cmd="sh /opt/gopath/src/github.com/hyperledger/fabric-samples/chaincode/abstore/go/test/the_command_b_july13.sh 0 95 2"
docker exec cli $cmd &

export cmd="sh /opt/gopath/src/github.com/hyperledger/fabric-samples/chaincode/abstore/go/test/the_command_b_july13.sh 0 95 3"
docker exec cli $cmd &

export cmd="sh /opt/gopath/src/github.com/hyperledger/fabric-samples/chaincode/abstore/go/test/the_command_b_july13.sh 0 95 4"
docker exec cli $cmd &

export cmd="sh /opt/gopath/src/github.com/hyperledger/fabric-samples/chaincode/abstore/go/test/the_command_b_july13.sh 0 95 5"
docker exec cli $cmd &

