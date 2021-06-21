#!/bin/bash
#
# Run locust load test
#
#####################################################################
ARGS="$@"
HOST="${1}"
SCRIPT_NAME=`basename "$0"`
INITIAL_DELAY=1
TARGET_HOST="$HOST"
NUM_USERS=2
RUN_TIME=5s
OUTPUT=""


do_check() {

  # check hostname is not empty
  if [ "${TARGET_HOST}x" == "x" ]; then
    echo "TARGET_HOST is not set; use '-h hostname:port'"
    exit 1
  fi

  # check for locust
  if [ ! `command -v locust` ]; then
    echo "Python 'locust' package is not found!"
    exit 1
  fi

  # check locust file is present
  if [ -n "${LOCUST_FILE:+1}" ]; then
    echo "Locust file: $LOCUST_FILE"
  else
    LOCUST_FILE="locustfile.py" 
    echo "Default Locust file: $LOCUST_FILE" 
  fi
}

do_exec() {
  sleep $INITIAL_DELAY

  # check if host is running
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" ${TARGET_HOST}) 
  if [ $STATUS -ne 200 ]; then
      echo "${TARGET_HOST} is not accessible"
      exit 1
  fi

  echo "Will run $LOCUST_FILE against $TARGET_HOST. Spawning $NUM_USERS for $RUN_TIME."
  locust --host=$TARGET_HOST -f $LOCUST_FILE --users=$NUM_USERS --spawn-rate=$NUM_USERS -t=$RUN_TIME $OUTPUT --headless --only-summary

  echo "done"
}

do_usage() {
    cat >&2 <<EOF
Usage:
  ${SCRIPT_NAME} [ hostname ] OPTIONS

Options:
  -d  Delay before starting
  -h  Target host url, e.g. http://localhost/
  -u  Number of NUM_USERS (default 2)
  -r  Number of RUN_TIME (default 10)
  -o  CSV output name.

Description:
  Runs a Locust load simulation against specified host.

EOF
  exit 1
}



while getopts ":d:h:u:t:o:" o; do
  case "${o}" in
    d)
        INITIAL_DELAY=${OPTARG}
        echo "INITIAL_DELAY=$INITIAL_DELAY"
        ;;
    h)
        TARGET_HOST=${OPTARG}
        echo "TARGET_HOST=$TARGET_HOST"
        ;;
    u)
        NUM_USERS=${OPTARG:-2}
        echo "NUM_USERS=$NUM_USERS"
        ;;
    t)
        RUN_TIME=${OPTARG:-5s}
        echo "RUN_TIME=$RUN_TIME"
        ;;
    o)
        OUTPUT=--csv=${OPTARG}
        echo "OUTPUT=$OUTPUT"
        ;;
    *)
        do_usage
        ;;
  esac
done


do_check
do_exec
