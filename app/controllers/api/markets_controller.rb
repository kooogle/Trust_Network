class Api::MarketsController < ApplicationController

  def hit_markets
    time_stamp = Market.intact_time(Time.now)
    Chain.all.each do |block|
      ticker = block.get_market
      Market.generate(block.id,ticker,time_stamp) if ticker['MarketName']
    end
    render json:{code:200}
  end

  def hit_day_bar
    Chain.all.each do |block|
      ticks = block.get_day_tick
      DayBar.generate(block,ticks) if ticks.size > 1
    end
    render json:{code:200}
  end
end