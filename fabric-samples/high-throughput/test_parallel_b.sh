#!/bin/bash

for (( i = 0; i < 16; ++i ))
do
  sh scripts/the_command_b_july13.sh $i &
done
