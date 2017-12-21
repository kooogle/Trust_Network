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

end
