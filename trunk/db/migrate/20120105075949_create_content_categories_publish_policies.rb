class CreateContentCategoriesPublishPolicies < ActiveRecord::Migration
  def self.up
    create_table :content_categories_publish_policies,:id=>false,:option=>'ENGINE InnoDB DEFAULT CHARSET=UTF8',:force=>true do |t|
      t.integer :publish_policy_id
      t.integer :content_category_id
    end
  end

  def self.down
    drop_table :content_categories_publish_policies
  end
end
