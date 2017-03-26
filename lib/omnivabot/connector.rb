require 'watir'
require 'watir/wait'
require 'headless'

module Omnivabot
	class Connector
		def self.discover(trackid)

			headless = Headless.new

			headless.start

			browser = Watir::Browser.new

			browser.goto('https://www.omniva.ee/abi/jalgimine')

			browser.text_field(id: 'websearch-keyword').set(trackid)

			browser.button(class: 'normal_button black_button').click

			# wait until query with trackid is done by omniva

			browser.wait_until {
				(browser.div(:id => 'barcode_search_result').h6.exists?) || (browser.div(:id => 'barcode_search_result').element(:class => 'table_on_white').exists?)
			}

			if browser.div(:id => 'barcode_search_result').h6.exists?
				system "notify-send 'Omniva Tracker' 'Package #{trackid} not found'"
				puts "Package #{trackid} not found"
			elsif browser.div(:id => 'barcode_search_result').element(:class => 'table_on_white').exists?
				system "notify-send 'Omniva Tracker' 'Package #{trackid} registered in system'"
				puts "Package #{trackid} registered in system."
			else
				system "notify-send 'Omniva Tracker' 'Internal error occurred.'"
				puts "Internal error occurred. Try again later."
			end

			browser.close
		end
	end
end

# Omnivabot::Connector.discover('RB183281587SG')
# Omnivabot::Connector.discover('RO327493673EE')