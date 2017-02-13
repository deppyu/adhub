require 'test_helper'
require 'ad_format'
require 'test/unit'
require 'ostruct'

class AdFormatTest < ActiveSupport::TestCase
  def setup
    AdFormat.clear
  end

  test "add format, without config block" do
    AdFormat.add 'text_icon', 'text and icon'
    assert_equal 1, AdFormat.formats.size
    format = AdFormat.formats[0]
    assert_equal 'text_icon', format.name
    assert_equal 'text and icon', format.note
  end

  test "for_device attribute" do
    format = AdFormat.new 'image', 'image format'
    format.for_device :mobile_phone
    assert format.is_for_device? :mobile_phone
    assert ! format.is_for_device?(:web)
  end

  test "for more than one device" do
    format = AdFormat.new 'image'
    format.for_device :mobile_phone
    format.for_device :web
    assert format.is_for_device? :mobile_phone
    assert format.is_for_device? :web
    assert ! format.is_for_device?(:misc)
  end

  test "for devices" do
    format = AdFormat.new 'image'
    format.for_device :mobile_phone, :web
    assert format.is_for_device? :mobile_phone
    assert format.is_for_device? :web
    assert ! format.is_for_device?(:misc)    
  end
  
  test "for unknown devices" do
    format = AdFormat.new 'image'
    assert_raise ArgumentError do
      format.for_device :unknown
    end
  end

  test "add format, with config block" do
    format = AdFormat.add('image') do |format|
      format.for_device :mobile_phone
    end
    assert format.is_for_device? :mobile_phone
  end

  test "find formats for device, found" do
    f1 = AdFormat.add('image') { |format| format.for_device :mobile_phone}
    f2 = AdFormat.add('icon_text') { |format| format.for_device :mobile_phone}
    formats = AdFormat.formats_for_device(:mobile_phone)
    assert_equal 2, formats.size
    assert formats.include?(f1)
    assert formats.include?(f2)
  end

  test "find formats for device, not found" do
    f1 = AdFormat.add('image') { |format| format.for_device :mobile_phone}
    f2 = AdFormat.add('icon_text') { |format| format.for_device :mobile_phone}
    formats = AdFormat.formats_for_device(:web)
    assert formats.empty?
  end

  test "add one simple resource" do
    format = AdFormat.add 'image' do |format|
      format.add_resource 'title', :text, :limit=>40
    end
    resource = format.resource_of_name 'title'
    assert_equal :text, resource.resource_type
    assert_equal 40, resource.options[:limit]
  end

  test "test find size code ." do
    format = AdFormat.add 'icon_text', 'icon and text' do |format|
      format.add_resource 'icon', :image, :sizes=>{ :square=>['80x80'] }
    end
    image = File.new(File.join(Rails.root, 'test', 'image', 'img_80_80.jpg'))
    assert_equal :square, format.size_code_for_resource_image('icon', image)
  end

  test "test find size code, unsupported image size" do
    format = AdFormat.add 'icon_text', 'icon and text' do |format|
      format.add_resource 'icon', :image, :sizes=>{ :square=>['90x90'] }
    end
    image = File.new(File.join(Rails.root, 'test', 'image', 'img_80_80.jpg'))
    assert_raise ArgumentError do
      format.size_code_for_resource_image('icon', image)    
    end
  end

  test "test find size code, not image resource" do
    format = AdFormat.add 'icon_text', 'icon and text' do |format|
      format.add_resource 'title', :text, :limit=>50
    end
    image = File.new(File.join(Rails.root, 'test', 'image', 'img_80_80.jpg'))
    assert_nil format.size_code_for_resource_image('title', image)    
  end

  test "test find size code, unknown resource name" do
    format = AdFormat.add 'icon_text', 'icon and text' do |format|
      format.add_resource 'icon', :image, :sizes=>{ :square=>['90x90'] }
    end
    image = File.new(File.join(Rails.root, 'test', 'image', 'img_80_80.jpg'))
    assert_raise ArgumentError do
      format.size_code_for_resource_image('unknown', image)    
    end    
  end

  test "test find size code, two sizes" do
    format = AdFormat.add 'icon_text', 'icon and text' do |format|
      format.add_resource 'image', :image, :sizes=>{ :square=>'80x80', :banner=>'800x100' }
    end
    image = File.new(File.join(Rails.root, 'test', 'image', 'img_80_80.jpg'))
    format.size_code_for_resource_image('image', image)    
  end
end
