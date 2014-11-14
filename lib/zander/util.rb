# Utility helpers
class Zander::Util
	def self.get_path(file_name)
		File.join((File.expand_path('../../', File.expand_path(File.dirname(__FILE__)))), file_name)
	end
end
