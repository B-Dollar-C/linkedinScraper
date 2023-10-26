class BaseProfile < ApplicationRecord
	has_secure_password
	serialize :metadata, Hash
end
