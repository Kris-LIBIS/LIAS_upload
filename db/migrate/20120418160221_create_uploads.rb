class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.integer :user_id
      t.string :name
      t.datetime :date
      t.integer :status
      t.text :info

      t.timestamps
    end
  end
end
