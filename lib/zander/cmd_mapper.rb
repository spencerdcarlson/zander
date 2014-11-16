module Zander
	module CommandMapper
		def self.map(site, driver, log, cmd)
			@site = site
			@driver = driver
			@log = log
			@cmd = cmd
			if cmd.is_a?(Hash)
				if cmd.has_key? :action
					Action.new(@site, @driver, @log, @cmd)
				elsif cmd.has_key? :manual
					Manual.set(@driver, @log)
					Manual.drive
					Manual.destroy
				else
					@log.error("Can't mapp comand for #{cmd.inspect}")
				end
			end
		end
	end
end