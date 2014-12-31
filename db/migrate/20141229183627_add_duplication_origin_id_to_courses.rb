class AddDuplicationOriginIdToCourses < ActiveRecord::Migration
  def up
    add_column :courses, :duplication_origin_id, :int
  end

  def down
    remove_column :courses, :duplication_origin_id
  end
end
