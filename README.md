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
* Set cron job to execute script
