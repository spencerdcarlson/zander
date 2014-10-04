Script to automaticlly log in a user to http://www.lynda.com

### Set Up ###
* Install ruby
    * See http://bit.ly/rbenvBrew to install with rbenv via homebrew
* Install bundler gem 
    * $ gem install bundler
* $ cd logIn
* $ bundle install
* edit config.yaml with your lynda.com credentials
* $ ruby log_in.rb
* Set cron job to execute script
