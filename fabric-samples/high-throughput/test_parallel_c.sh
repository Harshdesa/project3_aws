#!/bin/bash

for (( i = 0; i < 16; ++i ))
do
  sh /home/ec2-user/fabric-samples/high-throughput/scripts/the_command_c_july13.sh $i &
done
