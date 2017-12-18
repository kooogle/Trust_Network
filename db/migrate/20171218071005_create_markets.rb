class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets do |t|
      t.integer :chain_id, limit:5
      t.float   :bid
      t.float   :ask
      t.float   :high
      t.float   :low
      t.decimal :open_buy
      t.decimal :open_sell
      t.float   :prev_day
      t.float   :volume
      t.float   :base_volume
      t.decimal :time_stamp, precision:15

      t.timestamps null: false
    end
  end
end
