class CreateMarketplaces < ActiveRecord::Migration
  def up
    create_table :marketplaces do |t|
      t.string :name, null: false

      t.timestamp
    end
  end

  def down
    drop_table :marketplaces
  end
end
