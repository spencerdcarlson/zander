Automate User Logon to [Lynda.com](http://www.lynda.com)
---
### Set Up ###
* Install ruby
    * [Install](https://github.com/sstephenson/rbenv#homebrew-on-mac-os-x) ruby with [rbenv](https://github.com/sstephenson/rbenv) via [homebrew](http://brew.sh)
* Install bundler gem 
    * `$ gem install bundler`
    * [Here](http://dan.carley.co/blog/2012/02/07/rbenv-and-bundler/) is a great rbenv and bundler setup example
* `$ git clone git@github.com:spencerdcarlson/lyndaLogIn.git`
* `$ cd lyndaLogIn`
* `$ bundle install`
* Edit config.yaml with your lynda.com credentials
    * `$ vim config.yaml`
    * `$ git update-index --assume-unchanged config.yaml` *to remove config.yaml from git*
* `$ ruby log_in.rb`
* Set launchctl or cron job to execute script
---
Example launchctl job to run script once a month
* Save as .plist file under ~/Library/LaunchAgents directory
`<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
 	<key>Label</key>
 	<string>com.unique.name</string>

    <key>ProgramArguments</key>
    <array>
        <string>/path/to/ruby/script/log_in.rb</string>
    </array>

    <key>Nice</key>
    <integer>1</integer>

    <key>RunAtLoad</key>
    <true/>

    <key>StartCalendarInterval</key>
    <dict>
        <key>Minute</key>
        <integer>00</integer>
        <key>Hour</key>
        <integer>10</integer>
        <key>Day</key>
        <integer>1</integer>
    </dict>
</dict>
</plist>`

