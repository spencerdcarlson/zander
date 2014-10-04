Script to automaticlly log in a user to http://www.lynda.com
---
### Set Up ###
* Install ruby
    * See http://bit.ly/rbenvBrew to install with rbenv via homebrew
* Install bundler gem 
    * `$ gem install bundler`
    * [Here](http://dan.carley.co/blog/2012/02/07/rbenv-and-bundler/) is a great rbenv and bundler example blog
* `$ get clone https://github.com/spencerdcarlson/lyndaLogIn.giti`
* `$ cd lyndaLogIn`
* `$ bundle install`
* Edit config.yaml with your lynda.com credentials
* `$ ruby log_in.rb`
* Set cron job to execute script

To keep your config.yaml private remember to run: 
`$ git update-index --assume-unchanged config.yaml` after clone
