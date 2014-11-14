#####################################################################################################################
#  									ZANDER THE GREAT 																#
#						                   ,__ 																		#
# 						                   |  `'.																	#
# 						__           |`-._/_.:---`-.._ 																#
# 						\='.       _/..--'`__         `'-._ 														#
# 						 \- '-.--"`      ===        /   o  `', 														#
# 						  )= (                 .--_ |       _.' 													#
# 						 /_=.'-._             {=_-_ |   .--`-. 														#
# 						/_.'    `\`'-._        '-=   \    _.' 														#
# 						         )  _.-'`'-..       _..-'` 															#
# 						        /_.'        `/";';`| 																#
# 						                     \` .'/																	#
# 						                      '--'    																#
# 																													#
# 	Zander is a framerwork for facilitating automated Selenium webdriver testing 									#
# URLs and corrisponding log in credentials are defined in the share/sites.yaml										#
# The actions to be taken and the element identifiers are defined in share/actions.yaml								#
#####################################################################################################################
# lib = File.expand_path('../../lib/', __FILE__)
# $:.unshift lib unless $:.include?(lib)
# p $:.dup

class Zander
	def self.run
		steps = ARGV[0].split(',').map(&:to_i) unless ARGV[0] == nil
		s = Zander::Sites.new(Zander::Util.get_path('share/sites.yaml'),steps)
		s.add_actions(Zander::Util.get_path('share/actions.yaml'))
		s.set_log_level Logger::DEBUG
		s.sites.each do |site|
			site.drive
		end
	end
end

require 'zander/sites'
require 'zander/util'

