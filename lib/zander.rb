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
lib = File.expand_path('../../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
# p $:.dup

require 'logger'

module Zander
	@@log_level = nil
	LOG_FILE = STDOUT # 'log.txt'
	LOG = ::Logger.new(LOG_FILE,10,1024000)

	def self.run(sites: nil, actions: nil, steps: nil)
		LOG.level = Logger::INFO
		LOG.level = @@log_level unless @@log_level == nil

		if steps == nil
			steps = ARGV[0].split(',').map(&:to_i) unless ARGV[0] == nil
		end
		
		if (sites != nil && actions != nil)
			zander = Sites.new(sites,steps, LOG)
			zander.add_actions(actions)
		else
			zander = Sites.new(Util.get_path('share/sites.yaml'),steps, LOG)
			zander.add_actions(Util.get_path('share/actions.yaml'))
		end
		zander.sites.each do |site|
			site.drive
		end
	end

	def self.log_level(level)
		@@log_level = level
	end
end
require 'zander/cmd_mapper'
require 'zander/sites'
require 'zander/action'
require 'zander/manual'
require 'zander/site'
require 'zander/util'
require 'zander/ht'

require 'selenium-webdriver'
require 'yaml'




