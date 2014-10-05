class CreateCoursePurchases < ActiveRecord::Migration
  def up
    create_table :course_purchases do |t|
      t.integer :user_id
      t.integer :course_id

      t.timestamps
    end
  end

  def down
    drop_table :course_purchases
  end
end