class UserAfterRegistrationLoginService

	def self.get_return_response(user)
		obj = user.attributes.except(:password)#.slice('id','active','auth_token','user_id','email','encrypted_password','first_name','last_name','phone_no','role','profile_pic','state', 'country')
		obj.merge!(user_id: user.id)
	end
end