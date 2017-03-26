require 'omnivabot/version'
require 'watir'
require 'watir/wait'
require 'headless'
require 'json'

module Omnivabot
	class Connector
		def discover(trackid)

			headless = Headless.new

			# Making browser headless eg not showing to user
			headless.start

			browser = Watir::Browser.new

			browser.goto('https://www.omniva.ee/abi/jalgimine')

			# Filling tracking id
			browser.text_field(id: 'websearch-keyword').set(trackid)

			# Send request
			browser.button(class: 'normal_button black_button').click

			# wait until query with trackid is done by omniva

			browser.wait_until {
				(browser.div(:id => 'barcode_search_result').h6.exists?) ||
				(browser.div(:id => 'barcode_search_result').element(:class => 'table_on_white').exists?)
			}

			if browser.div(:id => 'barcode_search_result').h6.exists?

				# If yellow h6 error message is present
				puts "#{trackid}: not found from system"

			elsif browser.div(:id => 'barcode_search_result').element(:class => 'table_on_white').exists?

				# Package in system. Fetch data from table
				@activity = browser.table(:class => "table_on_white").tbody.tr.td(:index => 0).text
				@timeframe = browser.table(:class => "table_on_white").tbody.tr.td(:index => 1).text
				@trackid = trackid
				
				compare_activities(trackid)

			else
				puts "#{trackid}: error while fetching data."
			end

			browser.close
			headless.destroy
		end

		def compare_activities(trackid)

			# Let's see our existing data about trackable keys
			json = File.read('/home/koala/omnivabot/database.json')
			raw_data = JSON.parse(json)

			# Do we have any actual data about tracking key yet?
			if raw_data.key?(trackid)

				# Is the old activity same as new?
				if raw_data[trackid]['activity'] == @activity
					puts "#{trackid}: no updates."

				else
					old_activity = raw_data[trackid]['activity']
					puts "#{trackid}: #{@activity}. Previous: (#{old_activity})"
					raw_data[trackid]['activity'] = @activity
					notify("New activity: #{@activity}")
				end
			else

				# No, let's add it
				raw_data[trackid] = {
					:activity => @activity,
					:timeframe => @timeframe
				}
				# TODO: let user know!
				puts "#{trackid}: #{@activity}. Previous: N/A"
				notify("New activity: #{@activity}")
			end

			File.open("/home/koala/omnivabot/database.json","w") do |tracker|
  				tracker.write(JSON.pretty_generate(raw_data))
			end
		end
		def notify(message)
			system "notify-send 'Omniva Tracker: #{@trackid}' '#{message}'"
		end
	end
end