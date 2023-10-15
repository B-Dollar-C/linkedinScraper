class Api::V1::BasicDataController < ApplicationController
	def profile
		user_data = BasicDataService.overview(params[:profile_url])
		if user_data.present?
			render json: {code: 200, status: true, data: user_data}
		else
			render json: {code: 400, status: false, data: user_data, message: "Something went Wrong!"}, status: 400
		end
	end
end
