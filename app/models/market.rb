# t.integer  "chain_id",    limit: 5
# t.float    "bid",         limit: 24
# t.float    "ask",         limit: 24
# t.float    "high",        limit: 24
# t.float    "low",         limit: 24
# t.decimal  "open_buy",               precision: 10
# t.decimal  "open_sell",              precision: 10
# t.float    "prev_day",    limit: 24
# t.float    "volume",      limit: 24
# t.float    "base_volume", limit: 24
# t.decimal  "time_stamp",             precision: 15
# t.datetime "created_at",                            null: false
# t.datetime "updated_at",                            null: false

class Market < ActiveRecord::Base
  self.per_page = 20
  scope :latest, ->{ order(created_at: :desc)}

  def self.generate(block,data,time_stamp)
    m = Market.new
    m.chain_id = block
    m.bid = data['Bid']
    m.ask = data['Ask']
    m.high = data['High']
    m.low = data['Low']
    m.open_buy = data['OpenBuyOrders']
    m.open_sell = data['OpenSellOrders']
    m.prev_day = data['PrevDay']
    m.volume = data['Volume']
    m.base_volume = data['BaseVolume']
    m.time_stamp = time_stamp
    m.save
  end

  def self.intact_time(stamp)
    intact = Time.at(stamp).beginning_of_minute.to_i
    if stamp.to_i - intact > 30
      return intact + 60
    else
      return intact
    end
  end

end
