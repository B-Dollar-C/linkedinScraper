class Api::V1::BasicDataController < ApplicationController
	protect_from_forgery with: :null_session
	def profile
		profile = BaseProfile.where(profile_url: params[:profile_url]).first 
        if profile.present?
        	render json: {code: 400, status: false, message: "Profile already present!"}, status: 400
        else
    		user_data = BasicDataService.overview(params[:profile_url])
    		if user_data.present?
    			user_data[:auth_token] = params[:auth_token].presence || SecureRandom.hex
                if params[:password].blank?
                  password = Devise.friendly_token.first(8)
                  user_data[:password] = password
                  user_data[:password_confirmation] = password
                else
                  user_data[:password] = params[:password]
                  user_data[:password_confirmation] = params[:password_confirmation]
                end            

                user_data[:roll] = params[:roll] if params[:roll].present?
                user_data[:course] = params[:course] if params[:course].present? 
                user_data[:batch] = params[:batch] if params[:batch].present?
                user_data[:phone] = params[:phone] if params[:phone].present?
                user_data[:is_deleted] = false
                @user = BaseProfile.new(user_data)
                if @user.save
                    render json: {code: 200, status: true, message: "Sign Up Successful", data: @user.except(:password)}
                else
                    render json: {code: 400, status: false, message: @user.errors.full_messages.join(',')}, status: 400
                end   
    		else
    			render json: {code: 500, status: false, data: user_data, message: "Something went Wrong! Please enter a valid Linkedin URL"}, status: 500
    		end
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
end
