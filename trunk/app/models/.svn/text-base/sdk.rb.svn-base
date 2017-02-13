class Sdk < ActiveRecord::Base
  after_destroy :delete_file
  
  OS_ANDROID = 0

  ALL_OS_TYPE= [OS_ANDROID]
  
  UNUPLOAD_STATUS = 0
  UPLOADED_STATUS = 1
  ACTIVE_STATUS = 2
  
  ALL_STATUS = [UNUPLOAD_STATUS,UPLOADED_STATUS,ACTIVE_STATUS] 
  
  
  upload_column :file, :store_dir=>proc { |record, file| File.join('sdk', record.os_type.to_s) }
      
  validates_presence_of :os_type
  validates_presence_of :name  
  validates_presence_of :version
  
  def delete_file
    FileUtils.rm self.file.path, :force=>true if self.file
  end
end
