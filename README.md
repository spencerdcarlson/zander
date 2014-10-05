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
* Edit "/Users/sc/.rbenv/shims/ruby" in log_in.rb to be `$ which ruby`
* `$ bundle install`
* Edit config.yaml with your lynda.com credentials
    * `$ vim config.yaml`
    * `$ git update-index --assume-unchanged config.yaml` *to remove config.yaml from git*
* `$ ruby log_in.rb`
* Set launchctl or cron job to execute script

---

Example launchctl job to run script once a month
* `$ mv com.sc.lynda.login.plist ~/Library/LaunchAgents`
* Edit the .plist file to point to the log_in.rb file
* `$ launchctl load ~/Library/LaunchAgents/com.sc.lynda.login.plist`
