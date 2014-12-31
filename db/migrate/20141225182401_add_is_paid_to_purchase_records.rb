class AddIsPaidToPurchaseRecords < ActiveRecord::Migration
  def up
    add_column :purchase_records, :is_paid, :boolean, default: false
  end

  def down
    remove_column :purchase_records, :is_paid
  end
end
