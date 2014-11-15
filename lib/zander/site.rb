module Zander
	class Site
		attr_reader :parent
		attr_reader :actions
		attr_reader :log
		attr_reader :driver

		def initialize(parent:, hash:)
			@actions = Array.new
			@parent = parent unless parent == nil
			@log = parent.log unless parent.log == nil
			@driver = parent.driver unless parent.driver == nil
			create_attr_accessor(hash)
			parent.log.debug("Created #{self}")
		end

		def get_variables
	    	Hash[instance_variables.map { |name| [name, instance_variable_get(name)] } ]
	  	end

	  	# For each hash in the actions array, create 
	  	def add_actions(actions)
			actions.each do |action|
				# convert keys in action hash to symbols
				action = action.keys_to_sym
				@log.debug("Create action #{action}")
				self.actions.push(Action.new(site: self, hash: action))
			end
		end

		# Is this instance the last Site object defined in share/sites.yaml
		def is_last?
			@url != nil && @parent.sites.last.respond_to?(:url) && @parent.sites.last.url == @url
		end

		def drive()
			@driver.navigate.to self.url
			@log.info("Opened #{@driver.current_url}")
			self.actions.each do |action|
				action.drive
			end
		end

		# Creates instance variables for each key value in a given hash
		# { url => 'www.google.com', user_name => 'coolUser', password => 'secretPassword' }
		# would create the following instance variables
		# @url = 'www.google.com'
		# @user_name = 'coolUser'
		# @password = 'secretPassword'
		def create_attr_accessor(hash)
			hash.each do |key,value|
				value = value.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo} if value.is_a?(Hash)
				instance_variable_set("@#{key}", value)
				self.class.__send__(:attr_accessor, "#{key}")
	    		self.__send__("#{key}=", value)
			end
		end

		# Helper method for to_s 
		# returns a pretty string of all the actions
		def get_vars
			vars = ""
			vh = Hash[self.instance_variables.map {|name|[name, instance_variable_get(name)]}]
			vh.each_with_index do |(key,value), index|
				if key.to_s == "@parent" 
					vars << @parent.get_abbr_to_s
				elsif key.to_s == "@actions"
					@actions.each do |action|
						vars << action.to_s
					end
				elsif index == vh.size - 1 
					vars << "#{key}=\"#{value}\"" 
				else 
					"#{key}=\"#{value}\", " 
				end
			end
			vars
		end

		def inspect
			to_s
		end

		def to_s
			"<#{self.class.name}:0x#{'%x'%(self.object_id<<1)} #{get_vars}"
		end

	end
end