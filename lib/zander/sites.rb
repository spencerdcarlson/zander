module Zander
	class Sites
		IMPLICIT_WAIT = 10
		YAML_URL = 'URL'
		YAML_ACTIONS = 'ACTIONS'

		attr_reader :sites

		def initialize(yaml_file, steps = nil, log)
			@sites_yaml_file = yaml_file
			@log = log
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
			yaml = YAML::load(File.read(@sites_yaml_file))
			if yaml.has_key? 'WEBSITES'
				yaml['WEBSITES'].each_with_index do |site, index|
					if steps == nil
						@log.debug("Create site object for #{site['url']}")
						@sites.push(Site.new(parent: self, hash: site, driver: @driver, log: @log))
					else
						if steps.include?(index)
							@log.debug("Create site object for #{site['url']}")
							@sites.push(Site.new(parent: self, hash: site, driver: @driver, log: @log))
						end
					end
					
				end
			end
		end

		def get_site(url)
			@sites.each do |site|
				return site if site.url == url
			end
			nil
		end

		def get_abbr_to_s
			"<#{self.class.name}:0x#{'%x'%(self.object_id<<1)} ...>"
		end

		def add_actions(yaml_file)
			yaml = YAML::load(File.read(yaml_file))
			if yaml.has_key? 'WEBSITES'
				yaml['WEBSITES'].each do |website|
					if website.has_key?(YAML_URL) && website.has_key?(YAML_ACTIONS)
						site = self.get_site(website[YAML_URL])
						if site != nil
							@log.debug("Add #{website[YAML_ACTIONS]}")
							site.add_actions(website[YAML_ACTIONS])
						else
							@log.error("Error:: '#{website[YAML_URL]}' in #{yaml_file} was not in #{@sites_yaml_file}")	
						end
					else
						@log.error("#{yaml_file} doesn't contain a #{YAML_URL} array")
					end
				end
			else
				@log.error("#{yaml_file} doesn't contain a WEBSITES array")
			end
		end
	end
end