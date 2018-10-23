class AddUuidToUploadedFiles < ActiveRecord::Migration[5.2]
  def change
    add_column :uploaded_files, :uuid, :string
    add_index :uploaded_files, :uuid
  end
end
