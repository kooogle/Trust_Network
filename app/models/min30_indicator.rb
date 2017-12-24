# t.integer "chain_id",   limit: 8
# t.integer "market_id",  limit: 8
# t.float   "last_price", limit: 24
# t.float   "ma5",        limit: 24
# t.float   "ma15",       limit: 24
# t.float   "macd_fast",  limit: 24
# t.float   "macd_slow",  limit: 24
# t.float   "macd_dea",   limit: 24
# t.float   "macd_diff",  limit: 24
# t.decimal "time_stamp", precision: 15

class Min30Indicator < ActiveRecord::Base
  after_save :sync_ma_price
  after_save :sync_macd
  validates_uniqueness_of :time_stamp, scope: :chain_id

  def sync_ma_price
    if self.ma5.nil? || self.ma15.nil?
      self.update_attributes(ma5:self.recent_ema(5),ma15:self.recent_ema(15))
    end
  end

  def recent_ema(number)
    ema_array = Min30Indicator.where('time_stamp <= ? and chain_id = ?',self.time_stamp,self.chain_id).order(time_stamp: :asc).last(number).map {|x| x.last_price }
    average = (ema_array.sum / ema_array.size).round(8)
  end

  def sync_macd
    if self.macd_diff.nil?
      macd_array = self.macd(21,34,8)
      self.update_attributes(macd_fast:macd_array[0],macd_slow:macd_array[1],macd_diff:macd_array[2],macd_dea:macd_array[3])
    end
  end

  def macd(fast,slow,signal)
    pre_block = Min30Indicator.where('time_stamp < ? and chain_id = ?',self.time_stamp,self.chain_id).order(time_stamp: :asc).last
    if pre_block
      last_price = self.last_price
      ema_fast = pre_block.macd_fast
      ema_slow = pre_block.macd_slow
      ema_dea = pre_block.macd_dea
      fast_val =  last_price * 2 / (fast+1) + ema_fast * (fast - 2) / (fast + 1)
      slow_val =  last_price * 2 / (slow+1) + ema_slow * (slow - 2) / (slow + 1)
      diff_val = fast_val - slow_val
      dea_val =  diff_val * 2 / (signal + 1) + ema_dea *(signal - 2) / (signal + 1)
      bar_val = 2 * (diff_val - dea_val)
    else
      last_price = self.last_price
      fast_val =  last_price * 2 / (fast+1)
      slow_val =  last_price * 2 / (slow+1)
      diff_val = fast_val - slow_val
      dea_val =  diff_val * 2 / (signal + 1)
      bar_val = 2 * (diff_val - dea_val)
    end
    return [fast_val,slow_val,diff_val,dea_val]
  end

end
