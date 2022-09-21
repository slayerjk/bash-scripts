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
LOG_NAME=log-lsof_$(date +%F).log

LSOF_INTERVAL=2
TIME_TO_RUN=120


### LOGGING OPTIONS
### VALID ARE: pid, dir, both
### pid: LOG ONLY PID RELATED
### dir: LOG ONLY DIRS RELATED
### both: BOTH
OPTION=dir

### LOOKUP FOR PID(PID_NAME IS YOUR CHOICE)
PID_NAME='wazuh-syscheckd'

### DIRS TO INSPECT
### DIRECTORIES MUST EXIST!
DIR=/<your-dir>

#######################
# DONT'T EDIT FURTHER #
#######################

### REPORT/DEBUG settings
### Write STDOUT and STDERR in report; comment it for DEBUG!
LOG=$LOG_DIR/"$LOG_NAME"
exec 1>>"$LOG" 2>&1

date
ELAPSED_TIME=$((SECONDS - START_TIME))

function checking_pid () {
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
}

### OPTION pid ONLY
if [ "$OPTION" = "pid" ]; then
  checking_pid
  ### RUNNING LSOF WITH pid OPTON
  echo "Running script with PID option"
  while [ "$ELAPSED_TIME" -le "$TIME_TO_RUN" ]; do
    echo "=============="
    lsof -p "$PID"
    echo "Elased time is: $((SECONDS - START_TIME))"
    sleep $LSOF_INTERVAL
    ELAPSED_TIME=$((SECONDS - START_TIME))
  done
### OPTION both(PID&DIR)
elif [ "$OPTION" = "both" ]; then
  checking_pid
  ### RUNNING LSOF WITH both OPTON
  echo "Running script with both PID&DIR option"
  while [ "$ELAPSED_TIME" -le "$TIME_TO_RUN" ]; do
    echo "=============="
    lsof -p "$PID" +D "$DIR" -a
    echo "Elased time is: $((SECONDS - START_TIME))"
    sleep $LSOF_INTERVAL
    ELAPSED_TIME=$((SECONDS - START_TIME))
  done
### OPTION dir
elif [ "$OPTION" = "dir" ]; then
  ### RUNNING LSOF WITH dir OPTON
  echo "Running script with DIR option"
  while [ "$ELAPSED_TIME" -le "$TIME_TO_RUN" ]; do
    echo "=============="
    lsof +D "$DIR"
    echo "Elased time is: $((SECONDS - START_TIME))"
    sleep $LSOF_INTERVAL
    ELAPSED_TIME=$((SECONDS - START_TIME))
  done
fi

echo "###############"
echo "Script DONE!"
exit 0
