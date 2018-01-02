class CreateDayBars < ActiveRecord::Migration
  def change
    create_table :day_bars do |t|
      t.integer :chain_id, limit:5
      t.float   :open
      t.float   :close
      t.float   :high
      t.float   :low
      t.float   :volume
      t.float   :base_volume
      t.decimal :time_stamp, precision:15
    end
  end
end
