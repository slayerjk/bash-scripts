#!/usr/bin/env bash

#Defining PATH for commands
export PATH=$PATH:/usr/bin
# Setting Start time counter(seconds):
START_TIME=$SECONDS

##################
### SCRIPT INFO ##
##################

# Log-Lsof-by-Pid - this script purpose is to log all lsof outupt by PID
# By default script works for 2 minutes
# pgrep - must be installed
# lsof - must be installed

#################################################
#EDIT THIS SECTION
#################################################

LOG_DIR=/tmp
LOG_NAME=log-lsof-by-pid_$(date +%F).log

LSOF_INTERVAL=2
TIME_TO_RUN=120

### LOOKUP FOR PID(PID_NAME IS YOUR CHOICE)
PID_NAME='YOUR_PROCESS'

#######################
# DONT'T EDIT FURTHER #
#######################

PID=$(pgrep "$PID_NAME")

### CHECK PID EXISTS
if [ -z "$PID" ]; then
  echo "PID not found, exiting..."
  exit 1
else
  echo "PID found: $PID"
  echo "Stating to log lsof output for $PID"
  echo "When you've done, log is $LOG_DIR/$LOG_NAME"
fi
### REPORT/DEBUG settings
### Write STDOUT and STDERR in report; comment it for DEBUG!
LOG=$LOG_DIR/"$LOG_NAME"
exec 1>>"$LOG" 2>&1

date
ELAPSED_TIME=$((SECONDS - START_TIME))

while [ "$ELAPSED_TIME" -le "$TIME_TO_RUN" ]; do
  echo "=============="
  lsof -p "$PID"
  echo "--------------"
  echo "Elapsed time is: $((SECONDS - START_TIME))"
  sleep $LSOF_INTERVAL
  ELAPSED_TIME=$((SECONDS - START_TIME))
done

echo "Script DONE!"
echo "###############"
exit 0
