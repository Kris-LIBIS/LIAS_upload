class AddLocalPathToUploadedFile < ActiveRecord::Migration
  def change
    add_column :uploaded_files, :local_path, :string
  end
end
