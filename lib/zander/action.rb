module Zander
	class Action
		
		attr_reader :site
		attr_reader :driver
		attr_reader :log
		attr_reader :before_action
		attr_reader :action_type
		attr_reader :after_action

		def initialize(site, hash)
			@site = site
			@log = site.log
			@driver = site.driver
			@private_variable = false
			parse_before_action(hash)
			parse_action_type(hash)
			parse_after_action(hash)
			@log.debug("Created #{self.class.name} #{self}")
		end

		def private_variable?
			@private_variable
		end

		def parse_before_action(hash)
			if hash.has_key?(:before_action)
				@before_action = hash[:before_action]
			end
		end

		def parse_after_action(hash)
			if hash.has_key?(:after_action)
				@after_action = hash[:after_action]
			end
		end

		def parse_action_type(hash)
			if hash.has_key? :action_type
				@action_type = hash[:action_type]
				parse_type(hash)
			end
		end

		def parse_type(hash)
			case @action_type
			when 'click_element','print_element','switch_to_iframe'
				set_identifier(hash)
			when 'input_variable'
			 	set_identifier(hash)
			 	set_variable(hash)
			when 'input_data'
			 	set_identifier(hash)
			 	set_data(hash)
			when 'done','switch_to_new_window'
			else
			  @log.error("#{__method__} can't handle action_type #{@action_type} for #{self}")
			end
		end

		def set_identifier(hash)
			if hash.has_key? :identifier
				identifier = hash[:identifier]
			  	@finder_key = identifier.keys[0]
			  	@finder_value = identifier.values[0]
			end
		end

		def set_variable(hash)
			if hash.has_key? :variable
				@private_variable = true if hash[:variable] == "password"
				@variable = @site.instance_variable_get("@#{hash[:variable]}".to_sym)
			end
		end

		def set_data(hash)
			if hash.has_key? :data
				@data = hash[:data]
			end
		end

		def drive
			element = get_element
			do_action(element)
			sleep(1)
		end

		def get_element
			case @action_type
			when 'click_element', 'input_variable', 'print_element','switch_to_iframe', 'input_data'
				get_element_from_finders
			when 'done','switch_to_new_window'
		 	else
			  @log.error("Can't handle action_type #{@action_type} for #{self}")
			end
		end

		def get_element_from_finders
			if @finder_key != nil
				@log.debug("Find element #{@finder_key}='#{@finder_value}'")
				case @finder_key
				when :id,:name,:xpath
					element = @driver.find_element(@finder_key => @finder_value)
				when :css
				when :class
					# could be multiple // might need to add a n: 0 
					element = @driver.find_element(@finder_key => @finder_value)
				when :class_name
				when :link
				when :link_text
				when :partial_link_text
				when :tag_name
				else
					@log.error("#{__method__} invalid finder_key, must be a Selenium::WebDriver::SearchContext::FINDERS:")
					@log.error(Selenium::WebDriver::SearchContext::FINDERS.keys)
				end
			else
				@log.error("#{__method__} tried to locate element, but @finder_key == nil")
			end
			element
		end

		def get_elements_from_finders
			if @finder_key != nil
				@log.debug("Find elements #{@finder_key}='#{@finder_value}'")
				case @finder_key
				when :id
					element = @driver.find_elements(@finder_key => @finder_value)
				when :xpath
					element = self.driver.find_elements(:xpath, identifier[:xpath])
				when :css
				when :class
				when :class_name
				when :name
				when :link
				when :link_text
				when :partial_link_text
				when :tag_name
				else
					@log.error("#{__method__} invalid finder_key, must be a Selenium::WebDriver::SearchContext::FINDERS:")
					@log.error(Selenium::WebDriver::SearchContext::FINDERS.keys)
				end
			else
				@log.error("#{__method__} tried to locate element, but @finder_key == nil")
			end
			element
		end

		def do_action(element)
			@log.debug("try #{@action_type} #{@finder_key}='#{@finder_value}'")
			case @action_type
			when 'click_element'
				element.click
			when 'input_variable'
				@log.info("Send '#{masked_variable}' to #{@finder_key}='#{@finder_value}' element")
				element.clear
				element.send_keys @variable
			when 'print_element'
				@log.info("text: #{element.text}
					\t\ttag_name: #{element.tag_name}
					\t\tlocation: (#{element.location.x},#{element.location.y})")
			when 'input_data'
				@log.info("Send '#{@data}' to #{@finder_key}='#{@finder_value}' element")
				element.clear
				element.send_keys @data
			when 'switch_to_iframe'
				@log.error("Can't locate iframe with #{@finder_key}='#{@finder_value}'. iframe can only be located via 'id'") unless @finder_key == :id
				@driver.switch_to.frame(@finder_value)
				sleep(3)
			when 'switch_to_new_window'
				@log.debug("'main_window' saved")
				main_window = @driver.window_handle
				new_window = nil
				@driver.window_handles.each do |window|
	    			if main_window != nil && main_window != window
	      				new_window = window
	    			end
	  			end
	  			@log.error("Couldn't find new window") if new_window == nil
	  			@driver.switch_to.window(new_window)
	  			@log.debug("Switched to new window #{driver.current_url}")
	  			close_other_windows
			when 'done'
				close_other_windows
				@driver.quit if @site.is_last?
			else
				@log.error("Could not preform action #{@action_type} on #{@finder_key}='#{@finder_value}' element")
			end 
			@log.info("#{@action_type} #{@finder_key}='#{@finder_value}'")
		end

		def close_other_windows
			main_window = @driver.window_handle
			@driver.window_handles.each do |other_window|
	    		if main_window != nil && main_window != other_window
	      			@driver.switch_to.window(other_window)
	      			url = @driver.current_url
	      			@driver.close
	      			@log.debug("Closed window '#{url}'")
	    		end
	  		end
	  		@driver.switch_to.window(main_window)
		end

		def masked_variable
			if private_variable?
				clear = 3 #keep last 3 in clear text
				masked = @variable[0]; 
				(@variable.length-(clear+1)).times do
					masked << '*'
				end
				masked << @variable[(@variable.length-clear)...@variable.length]
			else
				@variable
			end
		end

		def inspect
			to_s
		end

		def to_s
			"<#{self.class.name}:0x#{'%x'%(self.object_id<<1)} @site=<Site:0x#{'%x'%(self.site.object_id<<1)} ...> @action_type=#{self.action_type} >"
		end
	end
end