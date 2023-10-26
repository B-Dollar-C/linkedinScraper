class AddEncryptedPasswordToBaseProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :base_profiles, :encrypted_password, :string, default: "", null: false
  end
end
