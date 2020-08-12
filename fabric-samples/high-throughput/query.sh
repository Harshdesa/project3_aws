source scripts/setenv.sh

for (( i = 0; i < 20; ++i ))
do
  peer chaincode query -C mychannel -n bigdatacc_$i -c '{"Args":["query","b"]}'
  peer chaincode query -C mychannel -n bigdatacc_$i -c '{"Args":["query","a"]}'
done
