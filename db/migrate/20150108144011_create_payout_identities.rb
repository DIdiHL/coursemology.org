class CreatePayoutIdentities < ActiveRecord::Migration
  def change
    create_table :payout_identities do |t|
      t.string :receiver_id
      t.string :receiver_type
      t.belongs_to :user

      t.timestamps
    end
  end
end
