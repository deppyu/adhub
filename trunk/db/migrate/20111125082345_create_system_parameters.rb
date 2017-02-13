class CreateSystemParameters < ActiveRecord::Migration
  def self.up
    create_table :system_parameters, :options => 'ENGINE InnoDB DEFAULT CHARSET=UTF8', :force=>true  do |t|
      t.string :name, :null=>false, :limit=>30
      t.integer :value_type, :null=>false, :default=>0
      t.integer :int_value
      t.float :float_value
      t.date  :date_value
      t.string :string_value, :limit=>1000
      t.datetime :time_value
      t.boolean :boolean_value
      t.timestamps
    end
  end

  def self.down
    drop_table :system_parameters
  end
end
