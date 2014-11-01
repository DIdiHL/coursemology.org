class CreatePurchaseRecords < ActiveRecord::Migration
  def up
    create_table :purchase_records do |t|
      t.belongs_to :course_purchase
      t.integer :seat_count, default: 0
      t.integer :seats_taken, default: 0
      t.decimal :price_per_seat, precision: 8, scale: 2

      t.timestamps
    end
  end

  def down
    drop_table :purchase_records
  end
end
