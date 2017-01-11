# MacBook Pro Battery Life Test

This repository contains a simple test script to emulate a relatively heavy workload for battery life testing. It downloads a copy of [Drupal VM](https://www.drupalvm.com) and repeatedly builds and destroys a Virtual Machine running Drupal.

The script does the following, in a loop:

  1. Write a counter, timestamp and the battery percentage (as reported by `pmset`) to a results file.
  3. Run `vagrant up` to configure a VM running Drupal on a standard LAMP stack.
  5. Run `vagrant destroy -f` to destroy the VM.
  6. Wait 10s.
  7. Repeat.

To run the script, you should already have the latest versions of [Vagrant](https://www.vagrantup.com/downloads.html) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads) installed.

> **Note about Vagrant plugins**: The author runs the tests without `vagrant-cachier` installed for consistency's sake. If you use Vagrant regularly, check to make sure you don't have any plugins installed which could affect the consistency of this test using `vagrant plugin list`!

## Usage

### Before running the test script

  1. **Disable Sleep**: Go to System Preferences > Energy Saver, click on the 'Battery' tab, and drag the 'Turn display off after' slider all the way to 'Never' (alternatively, you could run `caffeinate` in a separate Terminal window).
  2. **Disable Screen Saver**: Open System Preferences > Desktop & Screen Saver, then set the Screen Saver to 'Start after: Never'.
  3. **Turn up brightness**: For consistency's sake, turn up your screen brightness all the way (after the AC power has been disconnected).
  4. **Quit all other Applications**: To make it a fair comparison. (I also make sure all my Macs are running identical software configurations using the [Mac Development Ansible Playbook](https://github.com/geerlingguy/mac-dev-playbook)).

### Run the test script

  1. **Download project**: Download this project to your computer (either download through GitHub or clone it with Git). _Important Note_: Don't download the project in a 'cloud' directory (e.g. inside Dropbox, Google Drive, or a folder synced via iCloud).
  2. **Open Terminal (full screen)**: Open Terminal.app and put it in full screen mode (so the actual pixels displayed is identical from laptop-to-laptop).
  3. **Run Script**: Change into this project's directory (`cd path/to/macbook-pro-battery-test`). Run `./battery-test.sh`, and then walk away for a few hours.

After your Mac forces a sleep (when the battery has run out), plug it back in, then check the most recent file in `results/` in the project directory.

## Results

Results are written to a date-and-timestamped file inside the `results` folder. This file is in CSV format, so you can open it in Excel, Numbers, Google Sheets, or any other CSV-compatible program and graph the results as needed.

The results file has the following structure (as an example):

| Counter | Time                | Battery Percentage |
| ------- | ------------------- | ------------------ |
| 0       | 2017-01-07 15:58:40 | 100%               |
| 0       | 2017-01-07 16:10:48 | 98%                |
| 0       | 2017-01-07 16:17:22 | 94%                |
| ...     | ...                 | ...                |

Results of this script's test runs have been posted to the author's blog and a public Google Sheet:

  - Raw data in Google Sheets: [2016 MacBook Pro Battery Comparisons](https://docs.google.com/spreadsheets/d/16H6TeKCOZRwzsd5bZJM2IHVqN9fU6GZhUrDiu_SK2zU/edit?usp=sharing)
  - Blog post: [Battery Life - Why I Returned my 2016 MacBook Pro with Touch Bar](http://www.jeffgeerling.com/blog/2017/i-returned-my-2016-macbook-pro-touch-bar#battery-life)

## Author

This script was created by [Jeff Geerling](http://www.jeffgeerling.com) to run some more formal battery tests on the 2016 Retina MacBook Pro—both with and without Touch Bar—and to see if battery life and performance between the two models (under heavier load) was much different.
