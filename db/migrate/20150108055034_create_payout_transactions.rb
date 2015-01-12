class CreatePayoutTransactions < ActiveRecord::Migration
  def up
    create_table :payout_transactions do |t|
      t.string :payout_id
      t.string :payout_processor
      # The transaction id is used for retrieving results of
      # asynchronous requests.
      t.string :payout_transaction_id
      t.belongs_to :purchase_record

      t.timestamps
    end
  end

  def down
    drop_table :payout_transactions
  end
end
