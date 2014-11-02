class AddPublishedToPublishRecord < ActiveRecord::Migration
  def up
    add_column :publish_records, :published, :boolean, default: false
  end

  def down
    remove_column :publish_records, :published
  end
end
