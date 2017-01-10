#!/bin/bash
#
# MacBook Pro Battery Life Test Script
# Author: Jeff Geerling, 2017

# Detect if we're on AC or not.
case "$OSTYPE" in
  # see: http://stackoverflow.com/a/21249561
  darwin*) [[ $(pmset -g ps | head -1) =~ "AC Power" ]] && AC=1 || AC=0 ;;
  # see: https://github.com/oxyc/dotfiles/blob/master/.local/bin/battery
  linux*) AC=$(cat /sys/class/power_supply/AC/online) ;;
  # fallback to running the script.
  *) AC=0 ;;
esac

# Make sure we're on battery
if [ $AC -eq 1 ]; then
  printf "\033[0;31mPlease unplug power before starting the test.\033[0m\n"; exit 1;
fi

# Friendly reminder.
printf "Press [Ctrl+C] to stop the battery test...\n"

# Get the current time.
DATE="$(date +"%Y-%m-%d_%H.%M.%S")"

# Store results in a `results` directory.
RESULTS_DIR="results"
RESULTS_FILE="$RESULTS_DIR/$DATE.csv"
mkdir -p $RESULTS_DIR
touch $RESULTS_FILE || exit 1

# Print Header Row in result file.
printf "Counter,Time,Battery Percentage\n" >> $RESULTS_FILE

# Counter for how many times the script has looped.
TIMES_RUN=0

# Get Drupal VM.
curl -sSL https://github.com/geerlingguy/drupal-vm/archive/master.zip > drupalvm.zip
unzip -u drupalvm.zip
rm drupalvm.zip

# Create a config.yml script to install Drupal _inside_ the VM.
cat <<EOT >| drupal-vm-master/config.yml
vagrant_synced_folders: []
vagrant_synced_folder_default_type: 'rsync'
vagrant_hostname: macbook-pro-battery-test.dev
vagrant_machine_name: macbook_pro_battery_test
EOT

# 1 Infinte Loop.
while :
do
  # Write counter, time, and battery percentage to screen and file.
  TIMESTAMP="$(date +"%Y-%m-%d %H:%M:%S")"
  case "$OSTYPE" in
    darwin*) BATTERY_PERCENT="$(pmset -g batt | egrep "([0-9]+\%).*" -o --colour=auto | cut -f1 -d';')" ;;
    linux*) BATTERY_PERCENT="$(cat /sys/class/power_supply/BAT0/capacity)%" ;;
    *) BATTERY_PERCENT="?" ;;
  esac
  echo "$TIMES_RUN,$TIMESTAMP,$BATTERY_PERCENT" >> $RESULTS_FILE

  # Build Drupal VM.
  cd drupal-vm-master
  vagrant up

  sleep 10

  # Destroy Drupal VM instance.
  rm -rf drupal
  vagrant destroy -f
  cd ..

  TIMES_RUN=$((TIMES_RUN + 1))
done
