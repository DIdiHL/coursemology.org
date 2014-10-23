class CreatePublishRecords < ActiveRecord::Migration
  def up
    create_table :publish_records do |t|
      t.belongs_to :course
      t.belongs_to :marketplace

      t.timestamp
    end
  end

  def down
    drop_table :publish_records
  end
end
