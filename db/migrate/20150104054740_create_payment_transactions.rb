class CreatePaymentTransactions < ActiveRecord::Migration
  def up
    create_table :payment_transactions do |t|
      t.string :payment_processor
      t.string :payment_id
      t.belongs_to :purchase_record

      t.timestamps
    end
  end

  def down
    drop_table :payment_transactions
  end
end
