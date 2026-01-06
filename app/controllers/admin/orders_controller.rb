module Admin
  class OrdersController < BaseController
    before_action :set_order, only: [ :show, :update_status ]
    before_action :cleanup_old_orders, only: [ :index ]

    def index
      @orders = Order.includes(:user, :order_items).order(created_at: :desc)

      if params[:status].present?
        @orders = @orders.where(status: params[:status])
      end

      if params[:date].present?
        date = Date.parse(params[:date])
        @orders = @orders.where(created_at: date.beginning_of_day..date.end_of_day)
      end
    end

    def show
    end

    def update_status
      new_status = params[:status]

      if Order.statuses.key?(new_status) && @order.update(status: new_status)
        if new_status == "ready"
          LineNotifier.new.order_ready(@order)
        end
        redirect_to admin_order_path(@order), notice: "Status updated to #{new_status}."
      else
        redirect_to admin_order_path(@order), alert: "Failed to update status."
      end
    end

    private

    def set_order
      @order = Order.find(params[:id])
    end

    def cleanup_old_orders
      Order.where("created_at < ?", 30.minutes.ago).destroy_all
    end
  end
end
