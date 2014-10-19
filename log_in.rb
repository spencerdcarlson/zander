#!/usr/bin/env /Users/sc/.rbenv/shims/ruby
#####################################################################################################################
# Script to log in to lynda.com.                                                                                    #
# NOTICE you must either EDIT or DELETE the first line of this script                                               #
#                                                                                                                   #
# For launchd setup to execute this script on a schedule on Mac machines                                            #
# EDIT the first line as follows:                                                                                   #
#   Execute $ which ruby                                                                                            #
#   Change '/Users/sc/.rbenv/shims/ruby' to the result provided by the which comand                                 #
#                                                                                                                   #
# To run the script manually, you can either DELETE the first line or also follow the EDIT instructions above       #
#                                                                                                                   #
#####################################################################################################################

require 'selenium-webdriver'
require 'yaml'

driver = Selenium::WebDriver.for :firefox
wait = Selenium::WebDriver::Wait.new(:timeout => 10) 

def get_fully_qualified_path(file_name)
	return File.join File.expand_path(File.dirname(__FILE__)), file_name
end

def get_properties()
	config = YAML::load(File.read(get_fully_qualified_path('config.yaml')))
	if config.has_key?('LOGIN') && config.has_key?('PASSWORD')
		@login = config['LOGIN'][0] # get the first value for LOGIN
		@passwd = config['PASSWORD'][0] # get the frist value for PASSWORD
	end
	if config.has_key?('FIRST_NAME')
		@first_name = config['FIRST_NAME'][0]
	end
end

begin
	get_properties()
	driver.navigate.to "http://lynda.com"
    puts "#{Time.new} Opened #{driver.current_url}"
	login_modal = wait.until { driver.find_element(:id => "login-modal") }
	login_modal.click
	driver.switch_to.frame "fancybox-frame"
	usernameInput = wait.until { driver.find_element(:id => "usernameInput") }
	passwordInput = wait.until { driver.find_element(:id => "passwordInput") }
	lnk_login = wait.until { driver.find_element(:id => "lnk_login") }
	usernameInput.send_keys @login if @login
	passwordInput.send_keys @passwd if @passwd
	lnk_login.click
	guided_tour_cancel = wait.until { driver.find_element(:id => "guided-tour-cancel") }
	puts "#{Time.new} Logged In"
	guided_tour_cancel.click
	loggedInUser = wait.until { driver.find_element(:partial_link_text => 'Hi,') }
	user = loggedInUser.text; user.slice! 'Hi,'
	if user && @first_name
		if user.strip.upcase == @first_name.upcase
			puts "#{Time.new} User: #{user.capitalize}"
		else
			puts "#{Time.new} Wrong user!"
		end
	end
	loggedInUser.click
	log_out = wait.until { driver.find_element(:partial_link_text => 'Log out') }
	log_out.click
	puts "#{Time.new} Logged Out"
ensure
	driver.quit
    puts "#{Time.new} Closed session"
end
