#!/usr/bin/env bash

#Defining PATH for commands
export PATH=$PATH:/usr/bin
# Setting Start time counter(seconds):
START_TIME=$SECONDS

##################
### SCRIPT INFO ##
##################

# Log-Lsof-by-Pid - this script purpose is to log all lsof outupt(see OPTIONs)
# By default script works for 2 minutes
# pgrep - must be installed
# lsof - must be installed

#################################################
#EDIT THIS SECTION
#################################################

LOG_DIR=/tmp
LOG_NAME=log-lsof_$(date +%F).log

### LSOF SNAPSHOT ITNERVAL(sec), OVERALL TIME TO RUN(sec)
LSOF_INTERVAL=2
TIME_TO_RUN=40

### LOGGING OPTIONS
### VALID ARE: pid, dir, dirs, pdir
### pid: LOG ONLY PID RELATED
### dir: LOG ONLY DIRS RELATED
### dirs: LIST OF DIRS
### pdir: PID & DIR(one dir due to restrictions)
OPTION=pid

### LOOKUP FOR PID(PID_NAME IS YOUR CHOICE)
PROCESS_NAME='<your-process-name>'

### DIRS TO INSPECT
### DIRECTORIES MUST EXIST!
DIR=/var/ossec
DIRS=(/usr/bin /var/ossec /usr/lib)

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
  PID=$(pgrep "$PROCESS_NAME")
  ### CHECK PID EXISTS
  if [ -z "$PID" ]; then
    echo "PID not found, exiting..."
    exit 1
  else
    echo "Starting to log lsof output"
  fi
}

### OPTION pid ONLY
if [ "$OPTION" = "pid" ]; then
  checking_pid
  ### RUNNING LSOF WITH pid OPTON
  echo "Running script with PID option"
  echo "PROCESS_NAME is "$PROCESS_NAME""
  echo "PID is "$PID""
  while [ "$ELAPSED_TIME" -le "$TIME_TO_RUN" ]; do
    echo "=============="
    lsof -p "$PID"
    echo "Elapsed time is: $((SECONDS - START_TIME))"
    sleep $LSOF_INTERVAL
    ELAPSED_TIME=$((SECONDS - START_TIME))
  done
### OPTION pdir(PID&DIR)
elif [ "$OPTION" = "pdir" ]; then
  checking_pid
  ### RUNNING LSOF WITH both OPTON
  echo "Running script with PID&DIR option"
  echo "Running script with PID option"
  echo "PROCESS_NAME is "$PROCESS_NAME""
  echo "PID is "$PID""
  echo "DIR is "$DIR""
  while [ "$ELAPSED_TIME" -le "$TIME_TO_RUN" ]; do
    echo "=============="
    lsof -p "$PID" +D "$DIR" -a
    echo "Elapsed time is: $((SECONDS - START_TIME))"
    sleep $LSOF_INTERVAL
    ELAPSED_TIME=$((SECONDS - START_TIME))
  done
#### OPTION dir
elif [ "$OPTION" = "dir" ]; then
  ### RUNNING LSOF WITH dir OPTON
  echo "Running script with DIR option"
  echo "DIR is "$DIR""
  while [ "$ELAPSED_TIME" -le "$TIME_TO_RUN" ]; do
    echo "=============="
    lsof +D "$DIR"
    echo "Elapsed time is: $((SECONDS - START_TIME))"
    sleep $LSOF_INTERVAL
    ELAPSED_TIME=$((SECONDS - START_TIME))
  done
## OPTION dirs
elif [ "$OPTION" = "dirs" ]; then
  ### RUNNING LSOF WITH dirs OPTION
  echo "Running script with DIRS option"
  echo "DIRS are "$DIRS""
  while [ "$ELAPSED_TIME" -le "$TIME_TO_RUN" ]; do
    echo "=============="
    lsof +D "${DIRS[@]}"
    echo "Elapsed time is: $((SECONDS - START_TIME))"
    sleep $LSOF_INTERVAL
    ELAPSED_TIME=$((SECONDS - START_TIME))
  done
fi

echo "###############"
echo "Script DONE!"
exit 0
