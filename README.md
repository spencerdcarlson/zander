Script to automaticlly log in a user to http://www.lynda.com

### Set Up ###
1. Install ruby
    1.1 See http://bit.ly/rbenvBrew to install with rbenv via homebrew
2. Install bundler gem 
    2.1 $ gem install bundler
3. $ cd logIn
4. $ bundle install
5. edit config.yaml with your lynda.com credentials
6. $ ruby log_in.rb
7. Set cron job to execute script
