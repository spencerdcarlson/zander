module Zander
	class Action
		attr_reader :site
		attr_reader :identifier
		attr_reader :before_action
		attr_reader :action
		attr_reader :after_action
		attr_accessor :log
		attr_accessor :driver

		def initialize(site:, hash:)
			@site = site
			@identifier = parse_identifier(hash[:identifier]) if hash.has_key?(:identifier)
			@before_action = parse_before_action(hash[:before_action]) if hash.has_key?(:before_action)
			@action = parse_action(hash[:action]) if hash.has_key?(:action)
			@after_action = parse_after_action(hash[:after_action]) if hash.has_key?(:after_action)
			@log = @site.log
			@log.debug("Created #{self.class.name} #{self}")
			@driver = @site.driver

		end

		def parse_identifier(identifier)
			identifier
		end

		def parse_before_action(before_action)
			before_action
		end

		def parse_action(action)
			if action.is_a?(Hash)
				if action.has_key? :variable
					action =  Hash[:variable, self.site.instance_variable_get("@#{action[:variable]}".to_sym)]
				elsif action.has_key? :input
					#do nothing
				end
			end
			action
		end

		def parse_after_action(after_action)
			after_action
		end

		def drive
			element = get_element
			do_action(element)
			sleep(1)
		end

		def get_element
			return nil if @identifier == nil
			if @identifier.has_key? :iframe
				iframe_array = @identifier[:iframe]
				if iframe_array.is_a?(Array)
					for i in 0..iframe_array.size-1
						iframe_array[i] = iframe_array[i].keys_to_sym
					end
					iframe_hash = iframe_array.first
					iframe_id_hash = iframe_hash[:identifier]
					get_element_from_id(iframe_hash[:identifier]) # make sure iframe object is loaded on DOM
					self.log.debug("Switch to iframe (id: #{iframe_id_hash.values.first.to_s})")
					self.driver.switch_to.frame(iframe_id_hash.values.first.to_s)
					sleep(3)
					self.log.debug("Find iframe element")
					element = get_element_from_id(iframe_array[1][:identifier])
				end
			else
				element = get_element_from_id(@identifier)
			end
			element
		end

		def get_element_from_id(identifier)
			self.log.debug("Find element #{identifier}")
			if identifier.has_key? :xpath
				element = self.driver.find_element(:xpath, identifier[:xpath])
			else
				element = self.driver.find_element(identifier.keys.first => identifier.values.first)
			end
			element
		end

		def do_action(element)
			do_before_action
			if @action.is_a?(String)
				if  "click" == @action
					self.log.info("#{@action.capitalize} element #{self.identifier}")
					element.click
				elsif "print" == @action
					self.log.info("#{@action.capitalize} element #{self.identifier}
					text: #{element.text}
					tag_name: #{element.tag_name}
					location: (#{element.location.x},#{element.location.y})")
				elsif "done" == @action
					# do nothing
					close_other_windows
					self.driver.quit if @site.is_last?
				elsif "custom" == @action 
					Manual.set(self.driver,self.log)
					Manual.drive
					Manual.destroy
				end
			elsif @action.class == Hash
				@action.each do |key, value|
					self.log.info("Send Keys #{@action[key]} to #{self.identifier}")
					element.clear
					element.send_keys @action[key]# if @action.has_key?(:variable)

				end
			else
				self.log.error("Can't handle action")
			end
			do_after_action
		end

		def do_before_action
			if self.after_action != nil && self.after_action == "new_window"
				self.log.debug("@main_window saved")
				@main_window = self.driver.window_handle
			end
			if self.before_action != nil  
				if self.before_action == "get_patients_list"
					get_patients_list
				elsif self.before_action == "get_page_source"
					 self.log.debug("PAGE SOURCE!>> #{self.driver.page_source}")
				elsif self.before_action == "back_to_main_window"
					go_back_to_main_window
				end	
			end
		end

		def get_patients_list
			pages = self.driver.find_elements(:xpath,"//*[@id='printPortion']/table[3]/tbody/tr[3]/td/table[3]/thead/tr/td[2]/a")
			Patient.new(self.driver, pages, self.log)
		end

		def do_after_action
			if self.after_action != nil
				 go_to_new_window if self.after_action == "new_window"
			end
		end

		def go_to_new_window
			self.driver.window_handles.each do |window|
	    		if @main_window != nil && @main_window != window
	      			@new_window = window
	    		end
	  		end
	  		self.log.error("Couldn't find new window") if @new_window == nil
	  		self.driver.switch_to.window(@new_window)
	  		self.log.debug("Driver switched to new window")
		end

		def go_back_to_main_window
			self.log.error("Couldn't find @main_window to switch back to") if @main_window == nil
			self.driver.switch_to.window(@main_window)
			self.log.debug("Switched back to @main_window")
		end

		def close_other_windows
			main_window = self.driver.window_handle
			self.driver.window_handles.each do |other_window|
	    		if main_window != nil && main_window != other_window
	      			self.driver.switch_to.window(other_window)
	      			self.driver.close
	      			self.log.debug("Driver closed other window")
	    		end
	  		end
	  		self.driver.switch_to.window(main_window)
		end

		def inspect
			to_s
		end

		def to_s
			"<#{self.class.name}:0x#{'%x'%(self.object_id<<1)} @site=<Site:0x#{'%x'%(self.site.object_id<<1)} ...> @identifier=#{self.identifier} @action=#{self.action}>"
		end
	end
end