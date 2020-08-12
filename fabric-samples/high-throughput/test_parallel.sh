#!/bin/bash

for (( i = 0; i < 2; ++i ))
do
  sh scripts/the_command_b_july13.sh $i &
done
