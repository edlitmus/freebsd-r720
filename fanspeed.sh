#!/usr/bin/env bash

#set -x
set -e

FAN_SPEED=$1
HEX_SPEED=$(printf "0x%x\n" $FAN_SPEED)

ipmitool -I lanplus -H <IPMI_IP> -U <IPMI_USER> -P <IPMI_PASSWORD> raw 0x30 0x30 0x01 0x00
ipmitool -I lanplus -H <IPMI_IP> -U <IPMI_USER> -P <IPMI_PASSWORD> raw 0x30 0x30 0x02 0xff $HEX_SPEED
