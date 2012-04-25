class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :upload_directory, null: false
      t.string :contact

      t.timestamps
    end
  end
end
