class AddLocalPathToUploadedFile < ActiveRecord::Migration[5.2]
  def change
    add_column :uploaded_files, :local_path, :string
  end
end
