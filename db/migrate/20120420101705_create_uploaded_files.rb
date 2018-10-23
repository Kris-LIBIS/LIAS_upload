class CreateUploadedFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :uploaded_files do |t|
      t.integer :upload_id
      t.string :source_path
      t.string :relative_path
      t.string :file_name
      t.datetime :modification_date
      t.string :mimetype
      t.string :md5sum

      t.timestamps
    end
  end
end
