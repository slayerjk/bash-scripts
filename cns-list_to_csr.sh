#!/usr/bin/env bash

# CSR list file must be plain text file where each CN is in separate line

### Create results dir
RESULTS_DIR="Results_$(date +%d-%m-%y)"
# echo "Creating result dir for csrs"
if !  mkdir "$RESULTS_DIR" ;then
    echo "FAILED: to create request dir"
    exit 1
fi

### file with CN
read -rp "Enter FULL Path to CNs list:" CNS_FILE
while [ -z "$CNS_FILE" ]
do
  read -rp "Enter FULL Path to CNs list:" CNS_FILE
done

# Write output to log file from now
LOG_NAME=log
exec 1>$LOG_NAME 2>&1

### read CNS_FILE
echo "CNS_FILE=$CNS_FILE"
while IFS="" read -r CN || [ -n "$CN" ]
do
    # printf '%s\n' "$CN"

    ### Check CN
    if [ -z "$CN" ]; then
        continue
    fi
    # echo "CN=$CN"

    # create cn subdir in results dir
    CN_DIR="$RESULTS_DIR"/"$CN"
    if ! mkdir "$CN_DIR" ;then
      echo "failed to create CN_DIR = $CN_DIR"
      exit 1
    fi

    ### Execute reques and get csr and key
    if /usr/bin/openssl req -new -sha512 -nodes -out "$CN_DIR"/"$CN".csr -newkey rsa:2048 -keyout "$CN_DIR"/"$CN".key -subj "/CN=$CN"; then
        /usr/bin/chmod 777 "$CN_DIR"/*
        /usr/bin/rm -f config_temp
        # echo "SUCCESS!"
    else
      echo "FAILED! to create CSR & KEY for $CN"
      continue
    fi
done < "$CNS_FILE"

# making tar of results dir
if ! /usr/bin/tar -czf "$RESULTS_DIR".tar.gz "$RESULTS_DIR"; then
  echo "failed to make result tar"
fi

# deleting result dir
if ! /usr/bin/rm -rf "$RESULTS_DIR"; then
  echo "failed to del Results dir"
fi

echo "DONE!"
exit 0
