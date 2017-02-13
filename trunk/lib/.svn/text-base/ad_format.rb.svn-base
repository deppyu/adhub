# -*- coding: utf-8 -*-
require 'ostruct'
require 'RMagick'

class AdFormat
  class << self
    attr_accessor :formats
  end
  
  DEVICES = [:web, :mobile_phone, :pad]

  AdFormat.formats = []

  def self.clear
    self.formats= []
  end

  def self.add(name, note = '')
    format = self.new(name, note)
    yield(format) if block_given?
    self.formats << format
    format
  end

  def self.formats_for_device(device)
    self.formats.find_all { |format| format.is_for_device? device }
  end

  def self.of_name(name)
    self.formats.find { |f| name == f.name }
  end
  
  attr_accessor :name, :note, :variable_size, :to_json

  def initialize(name, note='')
    self.name = name
    self.note = note
    self.variable_size = false
    @for_device = []
    @resources = {}
  end

  def for_device(*devices)
    devices.each do |device|
      raise ArgumentError.new("unknown device type #{device}") unless DEVICES.include?(device)
      device = device.to_sym unless device.is_a?(Symbol)
      @for_device << device unless @for_device.include?(device)
    end
  end

  def is_for_device?(device)
    @for_device.include?(device.to_sym)
  end
  
  def add_resource(name, type, options={})
    resource = OpenStruct.new
    resource.resource_type = type
    resource.options = options
    @resources[name] = resource
  end

  def resource_of_name(name)
    @resources[name]
  end

  def store_dir_for_file(resource, file)
    File.join('ad_resource', resource.created_at.year.to_s, resource.created_at.month.to_s, resource.created_at.day.to_s, resource.id.to_s) 
  end

  def store_filename(resource, file)
    "#{resource.ad_format.name}_#{resource.name}.#{file.extension}"
  end

  def size_code_for_resource_image(resource_name, image)
    resource = self.resource_of_name(resource_name)
    raise ArgumentError.new("未知的资源名称: #{resource_name}。") if resource.nil?
    return nil unless :image == resource.resource_type
    image = ::Magick::Image.read(image.path)[0]
    iw, ih = image.columns, image.rows
    resource.options[:sizes].each_pair do |code, sizes|
      size = sizes.is_a?(Array) ? sizes[0] : sizes
      width, height = parse_size_string(size)
      return code if width == iw and height == ih
    end
    raise ArgumentError.new("不支持的图片尺寸 (#{iw}, #{ih})。")
  end

  def check_file_type(resource_name, file_name)
    if is_image_resource(resource_name) 
      raise ArgumentError.new('请上传一个jpg，gif或png文件。') unless is_image_file(file_name)
      return true
    end
    raise ArgumentError.new('该资源不能是一个文件。')
  end

  def is_image_resource(name)
    resource = self.resource_of_name(name)
    return false if resource.nil?
    :image == resource.resource_type
  end

  def is_text_resource(name)
    resource = self.resource_of_name(name)
    return false if resource.nil?
    :text == resource.resource_type    
  end

  def parse_size_string(size)
    size.split('x').collect { |s| s.to_i }
  end

  def size_codes
    return [] if self.variable_size
    codes = []
    self.resources.each do |r| 
      if :image == r.resource_type
        codes << r.options[:sizes].keys
      end
    end
    return codes.flatten
  end

  def json_for_ad(advertisement, size)
    self.to_json.call(advertisement, size)
  end

  private
  def is_image_file(file_name)
    ['.jpeg', '.jpg', '.gif', '.png'].include? File.extname(file_name).downcase
  end
end

