require 'test_helper'

class ListingStampsTest < ActionDispatch::IntegrationTest

	setup { host! 'api.example.com' }

	test 'returns a list of all stamps for a user' do
		get '/stamps'
		assert_equal 200, response.status
		refute_empty response.body
	end 

	test 'returns stamps filtered by stamps received' do
		stamp1 = Stamp.create!(name: 'amazon', stamped: true)
		stamp2 = Stamp.create!(name: 'softlayer', stamped: false)

		get '/stamps?stamped=true'
		assert_equal 200, response.status
		
		stamps = JSON.parse(response.body, symbolize_names: true)
		names = stamps.collect { |z| z[:name] }
		assert_includes names, 'amazon'
		refute_includes names, 'softlayer'
	end
end