module Zander
	module CommandMapper
		def self.map(site, hash)
			@site = site
			@hash = hash
			@log = site.log
			if hash.is_a?(Hash)
				if hash.has_key? :action
					Action.new(@site,@hash)
				elsif hash.has_key? :manual
					Manual.set(@site.driver, @log)
					Manual.drive
					Manual.destroy
				else
					@log.error("Can't mapp comand for #{hash.inspect}")
				end
			end
		end
	end
end