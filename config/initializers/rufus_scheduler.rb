#encoding : utf-8
require 'rufus-scheduler'
scheduler = Rufus::Scheduler.new

#每一分钟获取一次行情
scheduler.cron '*/1 * * * *' do
  Chain.all.each do |block|
    ticker = block.get_market.first
    Market.generate(block.id,ticker) if ticker['MarketName']
  end
end

