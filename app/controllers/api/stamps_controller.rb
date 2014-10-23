require 'Client'
module API
	class StampsController < ApplicationController
		skip_before_filter :verify_authenticity_token, only: [:verify_stamp, :verify_stamp_by_code]
		after_filter :cors_set_access_control_headers

	  # For all responses in this controller, return the CORS access control headers.
	  def cors_set_access_control_headers
	    headers['Access-Control-Allow-Origin'] = '*'
	    headers['Access-Control-Allow-Methods'] = 'POST,GET,OPTIONS'
	    headers['Access-Control-Max-Age'] = "1728000"
	  end

		def verify_stamp
			client = Client.new('9cdcd6624448930f2a74', '72d0390854ca3549378801d8be4348e4ae3f73bd')
		  @data = {"data" => params["data"]}

	    @consumer = OAuth::Consumer.new(
	      client.app_key, 
	      client.app_secret, 
	      {:site => "http://beta.snowshoestamp.com/api",
	      :scheme => :header
	      })

	    # Get Auth key with consumer
	    @resp = @consumer.request(:post, '/v2/stamp', nil, {}, @data, { 'Content-Type' => 'application/x-www-form-urlencoded' })
	    @response = JSON.parse(@resp.body)
		    
			#Create_or_find_by stamp name and write stamped to true. Then Query DB to send JSON.
	    if @response.include? 'stamp'
	    	if @response["stamp"]["serial"] == "gemini"
	    		stamp = Stamp.where(:name => "gemini").first_or_create
	    		stamp.use_count += 1
	    		stamp.save

	    	elsif @response["stamp"]["serial"] == "thurz"
	    		stamp = Stamp.where(:name => "thurz").first_or_create
	    		stamp.use_count += 1
	    		stamp.save

	    	elsif @response["stamp"]["serial"] == "deneia"
	    		stamp = Stamp.where(:name => "deneia").first_or_create
	    		stamp.use_count += 1
	    		stamp.save
	    	end

	    	#Deliver stamp serial and Download URL as JSON
	      data = Dlurl.deliver_url(@response, @response["stamp"]["serial"])
	      render json: data, status: 200
	    else
	   		#TODO: Redirect to Red Bull Error screen with/without input code failsafe
	      redirect_to "http://dotfury.com/snowshoe/error.html"
	    end
		end

		#Uncomment action below if want to enable input code failsafe if stamp fails
		# def verify_stamp_by_code
		# end

	end
end
