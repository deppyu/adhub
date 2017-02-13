class AdResource < ActiveRecord::Base
  belongs_to :member
  belongs_to :advertisement

  before_save :set_file_name
  after_destroy :delete_file

  upload_column :file, :store_dir=> proc { |record, file| record.ad_format.store_dir_for_file(record, file) },
  :filename=> proc { |record, file| record.ad_format.store_filename(record, file) }

  scope :unused, where(:advertisement_id=>nil)
  scope :old_than_one_day, where('created_at < ? ', Time.now - 24.hour)

  def self.clear_unused!
    self.unused.old_than_one_day.find_each(:batch_size=>100) { |res| res.destroy }
  end

  # def validate
  #   self.ad_format.validate_resource self
  # end
  def set_file_name
    write_attribute('file', self.file.filename) if self.file
  end

  def delete_file
    FileUtils.rm self.file.path, :force=>true if self.file
  end
  
  def ad_format
    @ad_format = AdFormat.of_name read_attribute('ad_format') if @ad_format.nil?
    @ad_format
  end

  def ad_format=(ad_format)
    @ad_format = ad_format
    if @ad_format
      write_attribute 'ad_format', @ad_format.name
    else
      write_attribute 'ad_format', nil
    end
  end

  def is_text_resource
    self.ad_format.is_text_resource(self.name)
  end

  def resource_def
    self.ad_format.resource_of_name(self.name)
  end
end
