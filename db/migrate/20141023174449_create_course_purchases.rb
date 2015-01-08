class CreateCoursePurchases < ActiveRecord::Migration
  def up
    create_table :course_purchases do |t|
      t.belongs_to :user
      t.belongs_to :publish_record

      t.timestamps
    end
  end

  def down
    drop_table :course_purchases
  end
end
