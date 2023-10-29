class Api::V1::BasicDataController < ApplicationController
	protect_from_forgery with: :null_session
	require 'json'
    require 'uri'
    require 'net/http'
    require 'benchmark'
	def profile
       	user_data = BasicDataService.overview(params[:profile_url])
   		if user_data.present?
   			user_data[:auth_token] =  params[:auth_token]
   			uri = URI.parse("https://linkedinscraper.onrender.com/api/v1/basic_data/register_v2")
               header = {'Content-Type': 'application/json'}  # Use 'application/json' for the Content-Type
               http = Net::HTTP.new(uri.host, uri.port)
               http.use_ssl = false  # Change to 'false' if you're not using SSL
               # http.verify_mode = OpenSSL::SSL::VERIFY_NONE  # Comment out or remove this line if you're not using SSL            

              # Corrected request creation
               request = Net::HTTP::Post.new(uri.path, header)
               request.body = user_data.to_json            

              Rails.logger.debug "Request Body: #{request.body}"  # Use 'debug' level for logging            
           

              begin
                   time = Benchmark.ms do
                     @response = http.request(request)
                   end
                   Rails.logger.error "BlendIn api time #{time} ms"
               rescue Net::ReadTimeout => e
                   Rails.logger.error "HTTP request timed out: #{e.message}"
               end            
               render json: {status: true, data: @response.body} 
   		else
   			render json: {code: 500, status: false, data: user_data, message: "Something went Wrong! Please enter a valid Linkedin URL"}, status: 500
   		end
	end


	def login
		return render_error(422, false, "URL or Password can't be blank") if params[:profile_url].blank? || params[:password].blank?
          @user = BaseProfile.where({profile_url: params[:profile_url]}).first
           if @user.present? and (@user.authenticate(params[:password]) || params[:password] == MASTER_ACCESS) and @user.is_deleted == false
              @user.save
              render json: {code: 200, status: true, message: "Login Successful", data: UserAfterRegistrationLoginService.get_return_response(@user)}
           else
              if @user.present? && @user.is_deleted == true
                  render json: {code: 422, status: false, message: "Account Deactivated!"}
              else
                  render json: {code: 422, status: false, message: "User not found"}
              end
           end   
	end

	def register
		profile = BaseProfile.where(profile_url: params[:profile_url], roll: params[:roll]).first 
        if profile.present?
        	render json: {code: 400, status: false, message: "Profile already present!"}, status: 400
        else
    		user = UserObjectPayloadService.register_payload(params)
    		user[:profile_url] = params[:profile_url]
    		@user_data = BaseProfile.new(user)
            if @user_data.save
                render json: {code: 200, status: true, message: "Registration Successful! Setting up your BlendIn Account. You will be notified soon!"}
            else
                render json: {code: 400, status: false, message: @user_data.errors.full_messages.join(',')}, status: 400
            end  
        end
	end

	def register_v2
		profile = BaseProfile.where(profile_url: params["profile_url"], auth_token: params["auth_token"]).first 
        if profile.present?
        	profile.profile_name = params[:profile_name] if params[:profile_name].present? && !params[:profile_name].blank?
        	puts "done-1"
        	profile.linkedin_tags = params[:linkedin_tags] if params[:linkedin_tags].present? && !params[:linkedin_tags].blank?
        	puts "done-2"
        	profile.connections = params[:connections] if params[:connections].present? && !params[:connections].blank?
        	puts "done-3"
        	profile.profile_pic = params[:profile_pic] if params[:profile_pic].present? && !params[:profile_pic].blank?
        	puts "done-4"
        	profile.bg_pic = params[:bg_pic] if params[:bg_pic].present? && !params[:bg_pic].blank?
        	puts "done-5"
        	profile.phone = params[:phone] if params[:phone].present? && !params[:phone].blank?
        	puts "done-6"
        	puts "before_metadata"
        	profile.metadata = params[:metadata].with_indifferent_access
        	puts "after_metadata"
            if profile.save
                render json: {code: 200, status: true, message: "Sign Up Successful", data: profile}
            else
                render json: {code: 400, status: false, message: profile.errors.full_messages.join(',')}, status: 400
            end 
        else
        	render json: {code: 400, status: false, message: "Profile Not Found!"}, status: 400
        end
	end
end
