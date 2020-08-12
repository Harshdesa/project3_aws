#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
# Exit on first error
set -e

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1
starttime=$(date +%s)
export TIMEOUT=10
export DELAY=3

# launch network; create channel and join peer to channel
pushd ../test-network
./network.sh down

echo "Bring up test network"
./network.sh up createChannel
popd

#set enviroment varialbes
export PATH=${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=$PWD/../config/

./scripts/install-chaincode.sh 0
for (( i = 0; i < 2; ++i ))
do
  #echo "$i $i $i Install high throughput chaincode on test network peers"
  #./scripts/install-chaincode.sh $i

  echo "$i $i $i Deploy high throughput chaincode to the channel"
  ./scripts/approve-commit-chaincode.sh $i
done

cat <<EOF

Total setup execution time : $(($(date +%s) - starttime)) secs ...

EOF
