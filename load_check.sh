#!/usr/bin/env bash

# set -x
set -e

LOAD=$(sysctl vm.loadavg | awk '{print $3}')
SPEED=10

if [[ ! -e /tmp/fanspeed ]]; then
    echo $SPEED | cat > /tmp/fanspeed
fi

if [[ `echo "if($LOAD < 1.0) 1" | bc` -eq 1 ]]; then
  SPEED=10
elif [[ `echo "if($LOAD < 2.0) 1" | bc` -eq 1 && `echo "if($LOAD >= 1.0) 1" | bc` -eq 1 ]]; then
  SPEED=20
elif [[ `echo "if($LOAD < 3.0) 1" | bc` -eq 1 && `echo "if($LOAD >= 2.0) 1" | bc` -eq 1 ]]; then
  SPEED=25
elif [[ `echo "if($LOAD < 4.0) 1" | bc` -eq 1 && `echo "if($LOAD >= 3.0) 1" | bc` -eq 1 ]]; then
  SPEED=30
elif [[ `echo "if($LOAD >= 4.0) 1" | bc` -eq 1 ]]; then
  SPEED=35
fi

PREV=`cat /tmp/fanspeed`

if [[ `echo "if($PREV != $SPEED) 1" | bc` -eq 1 ]]; then
    /usr/local/bin/fanspeed.sh $SPEED
    echo $SPEED | cat > /tmp/fanspeed
fi
