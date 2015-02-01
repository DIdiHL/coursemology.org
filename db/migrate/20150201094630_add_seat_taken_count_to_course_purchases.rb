class AddSeatTakenCountToCoursePurchases < ActiveRecord::Migration
  def up
    add_column :course_purchases, :seat_taken_count, :int, default: 0
  end

  def down
    remove_column :course_purchases, :seat_taken_count
  end
end
