module Zander
	module Manual
		def self.set(driver, log)
			@@driver = driver
			@@log = log
		end

		def self.drive
			## empty method to implement
		end

		def self.destroy
			@@driver = nil
			@@log = nil
		end
	end
end