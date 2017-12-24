class CreateMin30Indicators < ActiveRecord::Migration
  def change
    create_table :min30_indicators do |t|
      t.integer :chain_id, limit:5
      t.integer :market_id, limit:5
      t.float   :last_price
      t.float   :ma5
      t.float   :ma15
      t.float   :macd_fast
      t.float   :macd_slow
      t.float   :macd_dea
      t.float   :macd_diff
      t.decimal :time_stamp, precision:15
    end
  end
end
