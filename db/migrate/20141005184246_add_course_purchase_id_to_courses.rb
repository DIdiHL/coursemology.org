class AddCoursePurchaseIdToCourses < ActiveRecord::Migration
  def up
    add_column :courses, :course_purchase_id , :integer, references: :course_purchases
  end

  def down
    remove_column :courses, :course_purchase_id
  end
end
