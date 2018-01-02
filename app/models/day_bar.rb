# t.integer "chain_id",    limit: 8
# t.float   "open",        limit: 24
# t.float   "close",       limit: 24
# t.float   "high",        limit: 24
# t.float   "low",         limit: 24
# t.float   "volume",      limit: 24
# t.float   "base_volume", limit: 24
# t.decimal "time_stamp",  precision: 15

class DayBar < ActiveRecord::Base
  scope :date, -> { order("time_stamp") }
  validates_uniqueness_of :time_stamp, scope: :chain_id
  has_one :indicator, class_name:'DayIndicator'

  def self.generate(block,ticks)
    bars =  block.day_bars.date
    if bars.count < 10
      ticks.each do |day|
        DayBar.item_generate(block.id,day) rescue nil
      end
    end

    if ticks.count > bars.count && bars.count > 10
      exess = ticks.count - bars.count + 1
      ticks[-exess..-1].each do |day|
        DayBar.item_generate(block.id,day) rescue nil
      end
    end
  end

  def self.item_generate(id,bar)
    day = DayBar.new
    day.chain_id = id
    day.open = bar['O']
    day.close = bar['C']
    day.high = bar['H']
    day.low = bar['L']
    day.volume = bar['V']
    day.base_volume = bar['BV']
    day.time_stamp = bar['T'].to_time.to_i
    day.save
  end

  def generate_indicator
    if self.indicator.nil?
      ind = DayIndicator.new
      ind.chain_id = self.chain_id
      ind.day_bar_id = self.id
      ind.save
    end
  end

  def sync_ma_price
    if self.indicator && self.indicator.ma5.nil?
      self.indicator.update_attributes(ma5:self.recent_ema(5),ma10:self.recent_ema(10))
    end
  end

  def recent_ema(number)
    ema_array = DayBar.where('time_stamp <= ? and chain_id = ?',self.time_stamp,self.chain_id).order(time_stamp: :asc).last(number).map {|x| x.close }
    average = (ema_array.sum / ema_array.size).round(8)
  end

  def sync_macd
    if self.indicator && self.indicator.macd_diff.nil?
      macd_array = self.macd(21,34,8)
      self.indicator.update_attributes(macd_fast:macd_array[0],macd_slow:macd_array[1],macd_diff:macd_array[2],macd_dea:macd_array[3])
    end
  end

  def macd(fast,slow,signal)
    pre_block = DayBar.where('time_stamp < ? and chain_id = ?',self.time_stamp,self.chain_id).order(time_stamp: :asc).last
    if pre_block
      ind = pre_block.indicator
      last_price = self.close
      ema_fast = ind.macd_fast
      ema_slow = ind.macd_slow
      ema_dea = ind.macd_dea
      fast_val =  last_price * 2 / (fast+1) + ema_fast * (fast - 2) / (fast + 1)
      slow_val =  last_price * 2 / (slow+1) + ema_slow * (slow - 2) / (slow + 1)
      diff_val = fast_val - slow_val
      dea_val =  diff_val * 2 / (signal + 1) + ema_dea *(signal - 2) / (signal + 1)
      bar_val = 2 * (diff_val - dea_val)
    else
      last_price = self.close
      fast_val =  last_price * 2 / (fast+1)
      slow_val =  last_price * 2 / (slow+1)
      diff_val = fast_val - slow_val
      dea_val =  diff_val * 2 / (signal + 1)
      bar_val = 2 * (diff_val - dea_val)
    end
    return [fast_val,slow_val,diff_val,dea_val]
  end

end
