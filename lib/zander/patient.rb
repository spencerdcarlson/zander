class Patient
	require 'pdfkit'
	require 'fileutils'

	PATIENTS_DIR_PATH = "/Users/sc/Desktop/appeals/patients"
	PDF_PATH = "/Users/sc/Desktop/"

	attr_reader :driver
	attr_reader :pages
	attr_reader :log
	attr_accessor :file_count
	
	def initialize(driver, pages, log)
		log.debug("!!!Patient!!!")
		@file_count = 0
		@driver = driver
		@pages = pages
		@log = log
		get_patient_info # current page
		@pages.size.times do |i|
			@log.debug("Find element: //*[@id='printPortion']/table[3]/tbody/tr[3]/td/table[3]/thead/tr/td[2]/a[#{i+1}]")
			next_page_link = @driver.find_element(:xpath,"//*[@id='printPortion']/table[3]/tbody/tr[3]/td/table[3]/thead/tr/td[2]/a[#{i+1}]") #1st time [1] 2nd time [2]
			next_page_link_text = next_page_link.text
			next_page_link.click
			@log.debug("Click #{next_page_link_text}'")
			get_patient_info
			if next_page_link_text == "Next"
				2.times do |i|
					@log.debug("Find element: '//*[@id='printPortion']/table[3]/tbody/tr[3]/td/table[3]/thead/tr/td[2]/a[#{i+2}]")
					next_page_link = @driver.find_element(:xpath,"//*[@id='printPortion']/table[3]/tbody/tr[3]/td/table[3]/thead/tr/td[2]/a[#{i+2}]")
					next_page_link_text = next_page_link.text
					next_page_link.click
					@log.debug("Click link: #{next_page_link_text}")
					get_patient_info
				end
				#@log.debug("pages_after_next #{pages_after_next.size}")
			end		
		end
	end

	def get_patient_info
		patients = @driver.find_elements(:xpath,"//*[@id='printPortion']/table[3]/tbody/tr[3]/td/div[2]/table/tbody/tr")
		@log.debug("!!Number of patients #{patients.size}")
		@log.debug("Number of patients: #{patients.size}")
		patients.size.times do |i|
			@log.debug("Look for: //*[@id='printPortion']/table[3]/tbody/tr[3]/td/div[2]/table/tbody/tr[#{i+1}]/td[12]/a")
			patient_link = @driver.find_element(:xpath,"//*[@id='printPortion']/table[3]/tbody/tr[3]/td/div[2]/table/tbody/tr[#{i+1}]/td[12]/a")
			@log.debug("Find element Details")
			@log.debug("Save main window")
			@main_window = @driver.window_handle
			patient_link.click
			@log.debug("Click link: Detials")
			patient_name = driver.find_element(:xpath,"//*[@id='detailsearch']/tbody/tr/td/table[2]/tbody/tr[1]/td[2]")
			@patient_name_text = patient_name.text.gsub(/\s/,'_')
			@log.debug("Patient Name: #{@patient_name_text}")
			@date_of_service = @driver.find_element(:xpath,"//*[@id='printPortion']/table[3]/tbody/tr[1]/td[1]/table[1]/tbody/tr[3]/td/table/tbody/tr[2]/td/table[2]/tbody/tr[1]/td[2]/table/tbody/tr[1]/td/table/tbody/tr[2]/td[1]")
			@date_of_service_text = @date_of_service.text.gsub!(/\//,'-').gsub!(/\s/,'')
			@log.debug("Date of Service: #{@date_of_service_text}")
			print_link = @driver.find_element(:xpath,"//*[@id='printLink']/a[2]")
			print_link.click
			## Switch window
			go_to_new_window
			pdf_file_name = "UHC EOB #{@date_of_service_text}"
			print_pdf(pdf_file_name,@driver.page_source)
			## Switch back to main window
			@driver.switch_to.window(@main_window)
			@log.debug("Driver switched to Main window")
			@log.debug("New window url: #{@driver.current_url}")
			back_btn = @driver.find_element(:xpath, "//*[@id='printPortion']/table[3]/tbody/tr[1]/td[1]/table[1]/tbody/tr[6]/td/form/table/tbody/tr[2]/td/input")
			@log.debug("Found Back button")
			back_btn.click
			@log.debug("Click Back button")
		end
		# click next page <1 2 3>
	end

	def go_to_new_window
		@driver.window_handles.each do |window|
    		if @main_window != nil && @main_window != window
      			@new_window = window
    		end
  		end
  		@log.error("Couldn't find new window") if @new_window == nil
  		@driver.switch_to.window(@new_window)
  		@log.debug("Driver switched to new window")
  		@log.debug("New window url: #{@driver.current_url}")
	end

	def print_pdf(file_name,html)
		dir_path = "#{PATIENTS_DIR_PATH}/#{@patient_name_text}/"
  		FileUtils::mkdir_p dir_path
  		full_file = "#{dir_path}#{file_name}.pdf"
  		self.file_count = 0
  		while File.exist?(full_file)
  			self.file_count = self.file_count + 1
  			full_file = "#{dir_path}#{file_name}_#{self.file_count}.pdf"
  		end
  		kit = PDFKit.new(html)
  		pdf = kit.to_pdf
  		@log.debug("Create PDF file #{full_file}")
  		file = kit.to_file(full_file)
	end
end