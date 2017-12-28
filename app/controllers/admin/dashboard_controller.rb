class Admin::DashboardController < Admin::BaseController

  def index
    per_page = params[:per_page]
    block = params[:block] || Chain.first.id
    sta_time = params[:start]
    end_time = params[:end]
    @block = Chain.find(block)
    tickers = @block.markets
    tickers = tickers.where("time_stamp >= ? AND time_stamp <= ?",sta_time.to_time.beginning_of_day.to_i,end_time.to_time.end_of_day.to_i) if sta_time.present? && end_time.present?
    if per_page
      tickers = tickers.where("minute(created_at)%15=0") if per_page == '15min'
      tickers =tickers.where("minute(created_at)%30=0") if per_page == '30min'
      tickers =tickers.where("minute(created_at)=0") if per_page == '1h'
    end
    @date_array = tickers.map {|x| x.created_at.strftime('%m-%d %H:%M')}
    @stock_array = tickers.map {|x| x.bid }
  end

  def indicator
    sta_time = params[:start]
    end_time = params[:end]
    block = params[:block] || Chain.first.id
    @block = Chain.find(block)
    indicators = @block.min30_indicators
    if sta_time.present? && end_time.present?
      indicators = indicators.where("time_stamp >= ? AND time_stamp <= ?",sta_time.to_time.beginning_of_day.to_i,end_time.to_time.end_of_day.to_i)
    else
      indicators = indicators.last(96)
    end
    @date_array = indicators.map {|x| Time.at(x.time_stamp).strftime('%m-%d %H:%M')}
    @stock_ma5 = indicators.map {|x| x.ma5 }
    @stock_ma15 = indicators.map {|x| x.ma15 }
    stock_price = indicators.map {|x| x.last_price }
    @stock_array = combine(stock_price)
  end

  private
    def combine(stocks)
      arys = []
      pre_price = 0
      stocks.each do |last|
        pre_price = pre_price > 0 ? pre_price : last
        high = pre_price > last ? pre_price : last
        low = pre_price > last ? last : pre_price
        arys << [pre_price,last,low,high]
        pre_price = last
      end
      arys
    end
end
