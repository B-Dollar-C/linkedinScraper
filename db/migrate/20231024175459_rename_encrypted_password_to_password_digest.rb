class RenameEncryptedPasswordToPasswordDigest < ActiveRecord::Migration[6.1]
 def change
    rename_column :base_profiles, :encrypted_password, :password_digest
    add_column :base_profiles, :password, :string
  end
end
