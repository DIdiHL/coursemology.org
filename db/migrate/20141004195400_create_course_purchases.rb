class CreateCoursePurchases < ActiveRecord::Migration
  def up
    create_table :course_purchases do |t|
      t.belongs_to :user
      t.belongs_to :original_course, class: 'Course', foreign_key: 'original_course_id'
      t.belongs_to :duplicate_course, class: 'Course', foreign_key: 'duplicate_course_id'
      t.integer :seat_count

      t.timestamps
    end
  end

  def down
    drop_table :course_purchases
  end
end