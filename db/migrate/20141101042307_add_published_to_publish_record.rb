class AddPublishedToPublishRecord < ActiveRecord::Migration
  def up
    add_column :publish_records, :published, :boolean
  end

  def down
    remove_column :publish_records, :published
  end
end
