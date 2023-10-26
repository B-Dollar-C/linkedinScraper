class CreateBaseProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :base_profiles do |t|
      t.string :auth_token
      t.string :roll
      t.string :profile_name
      t.string :profile_url
      t.string :connect_url
      t.string :linkedin_tags
      t.string :connections
      t.string :profile_pic
      t.string :bg_pic
      t.text :metadata
      t.string :course
      t.string :batch
      t.string :phone
      t.boolean :is_deleted

      t.timestamps
    end

    add_index :base_profiles, :auth_token
    add_index :base_profiles, :roll
    add_index :base_profiles, :profile_url
    add_index :base_profiles, :profile_name
    add_index :base_profiles, :batch
    add_index :base_profiles, :phone
    add_index :base_profiles, :is_deleted
  end
end
