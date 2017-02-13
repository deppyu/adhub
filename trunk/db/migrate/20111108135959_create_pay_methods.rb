# encoding: UTF-8
class CreatePayMethods < ActiveRecord::Migration
  def self.up
    create_table :pay_methods, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true  do |t|
      t.integer :unit, :null=>false, :default=>0
      t.integer :pay_on, :default=>0
      t.string :name, :null=>false, :limit=>10
      t.string :note, :null=>false, :limit=>60
      t.string :effect_string, :string, :limit=>90
      t.timestamps
    end

  end

  def self.down
    drop_table :pay_methods
  end
end
