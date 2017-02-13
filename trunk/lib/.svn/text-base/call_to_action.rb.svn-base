require 'ostruct'

class CallToAction < Object
  class << self
    attr_accessor :actions
  end

  puts "initialize actions......"

  CallToAction.actions = []

  def self.add(name, note)
    action = CallToAction.new(name, note)
    yield action if block_given?
    self.actions << action
    action
  end

  def self.of_name(name)
    self.actions.find { |action| name == action.name }
  end

  attr_accessor :name, :note, :params

  def initialize(name, note)
    self.name = name
    self.note = note
    self.params = []
  end

  def add_param(name, note, options)
    param = OpenStruct.new
    param.name = name
    param.note = note
    param.options = options
    self.params << param
  end
end
