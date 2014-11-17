module Zander
	class Site

		def initialize(parent:, hash:, driver:, log:)
			@actions = Array.new
			@parent = parent unless parent == nil
			@log = log unless log == nil
			@driver = driver unless driver == nil
			create_attr_accessor(hash)
			@log.debug("Created #{self}")
		end

		def get_variables
	    	Hash[instance_variables.map { |name| [name, instance_variable_get(name)] } ]
	  	end

	  	# Map each hash in actions array with CommandMapper.
	  	# If the result is an Action object, add it to the acctions array
	  	def add_actions(actions)
			actions.each do |action|
				# convert keys in action hash to symbols
				action = action.keys_to_sym
				@log.debug("Create action #{action}")
				obj = CommandMapper.map(self, @driver, @log, action)
				@actions.push(obj) if obj.is_a?(Action)
			end
		end

		# Is this instance the last Site object defined in share/sites.yaml
		def last?
			@url != nil && @parent.sites.last.respond_to?(:url) && @parent.sites.last.url == @url
		end

		def drive()
			@driver.navigate.to self.url
			@log.info("Opened #{@driver.current_url}")
			@actions.each do |action|
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
				elsif key.to_s == "@password"
					vars << "#{key}=\"#{mask(value)}\""
				elsif index == vh.size - 1 
					vars << "#{key}=\"#{value}\""
				else 
					"#{key}=\"#{value}\", " 
				end
			end
			vars
		end

		def mask(var)
			clear = 3 #keep last 3 in clear text
			masked = var[0]; 
			(var.length-(clear+1)).times do
				masked << '*'
			end
			masked << var[(var.length-clear)...var.length]
		end

		def inspect
			to_s
		end

		def to_s
			"<#{self.class.name}:0x#{'%x'%(self.object_id<<1)} #{get_vars}"
		end

		private :to_s, :get_vars, :create_attr_accessor, :get_variables

	end
end