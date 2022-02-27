# freebsd-r720
scripts to manage a dell r720 running FreeBSD 

## fanspeed.sh

Use IPMI commands to set the fanspeed.

## load_check.sh

Checks the system load and uses the fanspeed.sh script to increase or decrease the fan speed. Best used in a cronjob to maintain sane fan levels.
