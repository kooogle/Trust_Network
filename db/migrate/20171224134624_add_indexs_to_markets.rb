class AddIndexsToMarkets < ActiveRecord::Migration
  def change
    add_index :markets, :time_stamp
    add_index :min30_indicators, :time_stamp
  end
end
