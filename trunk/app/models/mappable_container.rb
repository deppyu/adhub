class MappableContainer < AdContainer
  acts_as_mappable :lat_column_name=>:latitude, :lng_column_name=>:longitude, :default_units=>:kms
end
