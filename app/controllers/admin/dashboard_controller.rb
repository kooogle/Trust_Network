class Admin::DashboardController < Admin::BaseController

  def index
    per_page = params[:per_page]
    block = params[:block] || Chain.first.id
    sta_time = params[:start] || Date.current.to_s
    end_time = params[:end] || Date.current.to_s
    @block = Chain.find(block)
    tickers = @block.markets.where("time_stamp >= ? AND time_stamp <= ?",sta_time.to_time.beginning_of_day.to_i,end_time.to_time.end_of_day.to_i)
    tickers = tickers.last(per_page.to_i) if per_page.to_i > 0
    @date_array = tickers.map {|x| x.created_at.strftime('%H:%M')}
    @last_price = tickers.map {|x| x.bid }
  end

end
