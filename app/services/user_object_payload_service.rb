class UserObjectPayloadService

	def self.register_payload(params)
		user = {}
    user[:auth_token] = params[:auth_token].presence || SecureRandom.hex
    if params[:password].blank?
      password = Devise.friendly_token.first(8)
      user[:password] = password
      user[:password_confirmation] = password
    else
      user[:password] = params[:password]
      user[:password_confirmation] = params[:password_confirmation]
    end

    user[:roll] = params[:roll] if params[:roll].present?
    user[:course] = params[:course] if params[:course].present? 
    user[:batch] = params[:batch] if params[:batch].present?
    user[:phone] = params[:phone] if params[:phone].present?
    user[:is_deleted] = false
    user
  end
end