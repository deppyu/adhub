class CreateAdContainersContentCategories < ActiveRecord::Migration
  def self.up
    create_table :ad_containers_content_categories,:id=>false,:option=>'ENGINE InnoDB DEFAULT CHARSET=UTF8',:force=>true do |t|
      t.integer :ad_container_id,:option=>'CONSTRAINT FK_WITH_AD_GROUP REFERENCES ad_container(id)'
      t.integer :content_category_id,:option=>'CONSTRAINT FK_WITH_CONTENT_CATEGORY REFERENCES content_categories(id)'
    end
  end

  def self.down
    drop_table :ad_containers_content_categories
  end
end
