class Api::MarketsController < ApplicationController

  def hit_markets
    time_stamp = Market.intact_time(Time.now)
    Chain.all.each do |block|
      ticker = block.get_market.first
      Market.generate(block.id,ticker,time_stamp) if ticker['MarketName']
    end
    render json:{code:200}
  end
end