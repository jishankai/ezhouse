# coding: utf-8
class OrdersController < ApplicationController
  layout "apps"

  skip_before_action :verify_authenticity_token, only: [:notify]
  before_action :verify_alipay_notify, only: [:show, :notify]

  def new
  end

  def create
    order_number = "#{Time.now.to_s :number}-#{SecureRandom.hex(4)}"

    order = Order.new
    order.out_trade_no = order_number
    order.subject = "易房好介充值 #{order_number}",
    order.total_fee = params[:order][:money]
    order.user_id = current_user.id
    order.user_mobile = current_user.mobile
    order.user_type = 0
    order.save
    redirect_to Alipay::Service.create_direct_pay_by_user_url(
                  out_trade_no: order_number,
                  subject: order.subject,
                  total_fee: order.total_fee,
                  return_url: orders_url,
                  notify_url: notify_orders_url,
                )
  end

  def show
    redirect_to agent_path(current_user.agent)
  end

  def notify
    if @verify
      logger.info "Order #{params[:out_trade_no]} status: #{params[:trade_status]}"

      # business logic
      case params[:trade_status]
      when 'WAIT_BUYER_PAY'
      when 'TRADE_CLOSED'
      when 'WAIT_SUCCESS'
        order = Order.find_by( :out_trade_no => params[:out_trade_no])
        if order.present?
          agent = Agent.find_by( :mobile => order.mobile )
          if agent.present?
            agent.update( :money => agent.money+order.total_fee )
          else
            render text: 'fail'
          end
          order.trade_no = params[:trade_no]
          order.notify_time = params[:notify_time]
          order.seller_email = params[:seller_email]
          order.buyer_email = params[:buyer_email]
          order.seller_id = params[:seller_id]
          order.buyer_id = params[:buyer_id]
          order.trade_status = params[:trade_status]
          order.save
        else
          render text: 'fail'
        end
      when 'TRADE_PENDING'
      when 'TRADE_FINISHED'
      end

      render text: 'success'
    else
      render text: 'fail'
    end
  end

  private

  def verify_alipay_notify
    # params except :controller, :action, and other path params.
    @verify = Alipay::Notify.verify?(params.except(*request.path_parameters.keys))
    logger.info "Alipay notify verify: #{@verify}"
  end
end
