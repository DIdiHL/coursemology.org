class CreatePublishRecords < ActiveRecord::Migration
  def up
    create_table :publish_records do |t|
      t.belongs_to :course

      t.timestamps
    end
  end

  def down
    drop_table :publish_records
  end
end
