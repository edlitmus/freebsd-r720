#!/usr/bin/env bash

#set -x
#set -e

SPEED=10

if [[ ! -e /tmp/fanspeed ]]; then
    echo $SPEED | cat > /tmp/fanspeed
fi

ave_temp () {
  local TEMP_C=0
  local COUNT=0
  for temp in $(sysctl dev.cpu | grep temperature | awk '{print $2}' | cut -d 'C' -f 1); do
    TEMP_C=$(echo $temp + $TEMP_C | bc)
    COUNT=$(echo "$COUNT" + 1 | bc)
  done

  AVE_TEMP=$(echo "$TEMP_C" / "$COUNT" | bc)

  if [[ `echo "if($AVE_TEMP < 45) 1" | bc` -eq 1 ]]; then
    SPEED=10
  elif [[ `echo "if($AVE_TEMP < 55) 1" | bc` -eq 1 && `echo "if($AVE_TEMP >= 45) 1" | bc` -eq 1 ]]; then
    SPEED=20
  elif [[ `echo "if($AVE_TEMP < 65) 1" | bc` -eq 1 && `echo "if($AVE_TEMP >= 55) 1" | bc` -eq 1 ]]; then
    SPEED=30
  elif [[ `echo "if($AVE_TEMP < 75) 1" | bc` -eq 1 && `echo "if($AVE_TEMP >= 65) 1" | bc` -eq 1 ]]; then
    SPEED=40
  elif [[ `echo "if($AVE_TEMP >= 85) 1" | bc` -eq 1 ]]; then
    SPEED=100
  fi

  echo "$SPEED"
}

load_speed () {
  local SPEED=10
  local LOAD=$(sysctl vm.loadavg | awk '{print $3}')

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

  echo "$SPEED"
}

TEMP_SPEED="$(ave_temp)"
LOAD_SPEED="$(load_speed)"

if [[ $TEMP_SPEED -ge $LOAD_SPEED ]]; then
  SPEED=$TEMP_SPEED
else
  SPEED=$LOAD_SPEED
fi

PREV=`cat /tmp/fanspeed`

if [[ `echo "if($PREV != $SPEED) 1" | bc` -eq 1 ]]; then
    /usr/local/bin/fanspeed.sh $SPEED
    echo $SPEED | cat > /tmp/fanspeed
fi

exit
