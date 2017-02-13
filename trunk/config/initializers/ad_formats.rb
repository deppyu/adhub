# encoding: UTF-8
require 'ad_format'

AdFormat.add 'icon_text', '图标加文字' do |format|
  format.for_device :mobile_phone, :pad, :web
  format.variable_size = true
  format.add_resource 'icon', :image, :sizes=>{ :square => '80x80' }
  format.add_resource 'title', :text, :limit=>40
  format.add_resource 'subtitle', :text, :limit=>40
  format.to_json = Proc.new { |ad, size| 
    { :format=>'icon_text', 
      :icon=>ad.resource_of_name('icon').file.url, 
      :title=>ad.resource_of_name('title').text,
      :subtitle=>ad.resource_of_name('subtitle').text } 
  }
end

AdFormat.add 'image', '图片广告' do |format|
  format.for_device :mobile_phone, :pad, :web
  format.add_resource 'image', :image, :sizes=>{ :m_banner_p => '640x100', :m_banner_l=>'800x75', :square=>'400x400' }
  format.to_json = Proc.new { |ad, size|
    res = ad.resource_of_size size
    { :format=>'image', :url=>res.file.url }
  }
end
