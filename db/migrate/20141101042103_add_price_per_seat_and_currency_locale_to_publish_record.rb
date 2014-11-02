class AddPricePerSeatAndCurrencyLocaleToPublishRecord < ActiveRecord::Migration
  def up
    add_column :publish_records, :price_per_seat, :decimal, precision: 8, scale: 2, default: 0
  end

  def down
    remove_column :publish_records, :price_per_seat
  end
end
