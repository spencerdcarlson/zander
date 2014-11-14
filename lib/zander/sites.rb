class Zander::Sites
	require 'json'
	require 'selenium-webdriver'
	require 'yaml'
	require 'logger'
	require_relative 'site'
	
	IMPLICIT_WAIT = 10
	YAML_URL = 'URL'
	YAML_ATTRIBUTES = 'ATTRIBUTES'
	LOG_FILE = STDOUT # 'log.txt'

	attr_reader :sites
	attr_accessor :driver
	attr_accessor :wait
	attr_accessor :log

	def initialize(yaml_file, steps = nil)
		@log = Logger.new(LOG_FILE,10,1024000)
		@log.level = Logger::DEBUG
		@sites = Array.new
		### FIREFOX PROFILE
		profile = Selenium::WebDriver::Firefox::Profile.new
		profile['browser.download.dir'] = '/Users/sc/Desktop/appeals/HCFA_AND_POTF'
		profile['browser.download.folderList'] = 2
		profile['browser.helperApps.neverAsk.saveToDisk'] = "application/pdf"
		profile['browser.download.alertOnEXEOpen'] = false
		profile['browser.download.manager.showWhenStarting'] = false
		profile['browser.download.manager.focusWhenStarting'] = false
		profile['browser.helperApps.alwaysAsk.force'] = false
		profile['browser.download.manager.alertOnEXEOpen'] = false
		profile['browser.download.manager.closeWhenDone'] = false
		profile['browser.download.manager.showAlertOnComplete'] = false
		profile['browser.download.manager.useWindow'] = false
		profile['browser.download.manager.showWhenStarting'] = false
		profile['services.sync.prefs.sync.browser.download.manager.showWhenStarting'] = false
		profile['pdfjs.disabled'] = true
		## END FIREFOX PROFILE
		@driver = Selenium::WebDriver.for :firefox, :profile => profile
		@driver.manage.timeouts.implicit_wait = IMPLICIT_WAIT
		@log.debug("Selenium timeouts set to #{IMPLICIT_WAIT} seconds")
		yaml = YAML::load(File.read(yaml_file))
		if yaml.has_key? 'WEBSITES'
			yaml['WEBSITES'].each_with_index do |site, index|
				if steps == nil
					@log.debug("Create Site #{site}")
					@sites.push(Site.new(parent: self, hash: site))
				else
					if steps.include?(index)
						@log.debug("Create Site #{site}")
						@sites.push(Site.new(parent: self, hash: site))
					end
				end
				
			end
		end
	end

	def set_log_level(level)
		@log.level = level
	end

	def get_site(url)
		self.sites.each do |site|
			return site if site.url == url
		end
		nil
	end

	def get_abbr_to_s
		"<#{self.class.name}:0x#{'%x'%(self.object_id<<1)} ...>"
	end

	def add_actions(yaml_file)
		yaml = YAML::load(File.read(yaml_file ))
		if yaml.has_key? 'WEBSITES'
			yaml['WEBSITES'].each do |website|
				if website.has_key?(YAML_URL) && website.has_key?(YAML_ATTRIBUTES)
					site = self.get_site(website[YAML_URL])
					if site != nil
						@log.debug("Add #{website[YAML_ATTRIBUTES]}")
						site.add_actions(website[YAML_ATTRIBUTES])
					end
				end
			end
		end
	end
end