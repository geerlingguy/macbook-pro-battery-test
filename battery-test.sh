#!/bin/bash
#
# MacBook Pro Battery Life Test Script
# Author: Jeff Geerling, 2017

# Make sure we're on battery (see: http://stackoverflow.com/a/21249561).
if [[ $(pmset -g ps | head -1) =~ "AC Power" ]]; then
  printf "\033[0;31mPlease unplug power before starting the test.\033[0m\n"; exit 1;
fi

# Friendly reminder.
printf "Press [Ctrl+C] to stop the battery test...\n"

# Get the current time.
DATE="$(date +"%Y-%m-%d_%H.%M.%S")"

# Store results in a `results` directory.
RESULTS_DIR="results"
RESULTS_FILE="$RESULTS_DIR/$DATE.txt"
mkdir -p $RESULTS_DIR
touch $RESULTS_FILE || exit 1

# Print Header Row in result file.
printf "Counter,Time,Battery Percentage\n" >> $RESULTS_FILE

# Counter for how many times the script has looped.
TIMES_RUN=0

# Get Drupal VM.
curl -sSL https://github.com/geerlingguy/drupal-vm/archive/master.zip > drupalvm.zip
unzip drupalvm.zip
rm drupalvm.zip

# 1 Infinte Loop.
while :
do
  # Write counter, time, and battery percentage to screen and file.
  TIMESTAMP="$(date +"%Y-%m-%d %H:%M:%S")"
  BATTERY_PERCENT="$(pmset -g batt | egrep "([0-9]+\%).*" -o --colour=auto | cut -f1 -d';')"
  echo "$TIMES_RUN,$TIMESTAMP,$BATTERY_PERCENT" >> $RESULTS_FILE

  # Build Drupal VM.
  cd drupal-vm-master
  vagrant up

  sleep 10

  # Destroy Drupal VM instance.
  vagrant destroy -f
  cd ..

  TIMES_RUN=$((TIMES_RUN + 1))
done
