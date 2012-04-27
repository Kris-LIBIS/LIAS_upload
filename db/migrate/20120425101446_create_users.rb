class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :upload_dir, null: false
      t.integer :organization_id, null: false
      t.boolean :admin, null: false, default: false
      t.string :password_digest

      t.timestamps
    end
  end
end
