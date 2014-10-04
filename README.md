Script to automaticlly log in a user to http://www.lynda.com

### Set Up ###
* Install ruby
    * See http://bit.ly/rbenvBrew to install with rbenv via homebrew
* Install bundler gem 
    * $ gem install bundler
* $ get clone https://github.com/spencerdcarlson/lyndaLogIn.git 
* $ cd lyndaLogIn
* $ bundle install
* Edit config.yaml with your lynda.com credentials
* $ ruby log_in.rb
* Set cron job to execute script

To keep your config.yaml private remember to run `$ git update-index --assume-unchanged config.yaml` after clone
