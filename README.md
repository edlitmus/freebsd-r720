# freebsd-r720
scripts to manage a dell r720 running FreeBSD 

## fanspeed.sh

Use IPMI commands to set the fanspeed. It takes a number representing the percentage of the speed to set (10 for 10%, etc).

Information for the IPMI commands came from here:

[Reduce the fan noise of the Dell R720XD (plus other 12th gen servers) with IPMI](https://back2basics.io/2020/05/reduce-the-fan-noise-of-the-dell-r720xd-plus-other-12th-gen-servers-with-ipmi/)

## load_check.sh

Checks the system load and uses the fanspeed.sh script to increase or decrease the fan speed. Best used in a cronjob to maintain sane fan levels.
