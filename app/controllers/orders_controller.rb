class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :destroy, :resend, :update, :email, :upload]

  require 'csv'

  respond_to :html, :js

  def index
    @event = Event.find params.require(:event_id)

    authorize! :read, @event

    @ordersgrid = OrdersGrid.new(params[:orders_grid]) do |scope|
      scope.where(event_id: @event.id).order('orders.price - paid DESC')
    end

    @orders = @ordersgrid.assets
    @orders = @orders.paginate(page: params[:page], per_page: 25)
  end

  def new
    @event = Event.find params.require(:event_id)
    @orders = Order.new
  end

  def destroy
    @event = Event.find params.require(:event_id)
    authorize! :destroy, @event
    order = Order.find params.require(:id)
    @id = order.id
    order.destroy
  end

  def info
    @order = Order.find params.require(:id)
    authorize! :read, @order.event
  end

  def resend
    @order = Order.find params.require(:id)
    authorize! :update, @order.event

    @order.deliver
  end

  def create
    @event = Event.find params.require(:event_id)

    # Check if the user can register
    authorize! :register, @event

    render 'events/show'
  end

  def update
    @order = Order.find params.require(:id)
    authorize! :update, @order

    paid = @order.paid
    @order.update params.require(:order).permit(:to_pay)
    @order.deliver if @order.paid != paid # Did the amount change?

    respond_with @order
  end

  def email
    @event = Event.find params.require(:event_id)
    authorize! :read, @event

    to = @event.orders.pluck(:email)

    MassMailer.general_message(@event.contact_email, to, params['email']['subject'], params['email']['body']).deliver_now

    redirect_to event_orders_path(@event)
  end

  def upload
    @event = Event.find params.require(:event_id)
    authorize! :update, @event
    sep = params.require('separator')
    paid = params.require('amount_column').upcase
    fails = []
    counter = 0

    begin
      CSV.parse(params.require(:csv_file).read.upcase, col_sep: sep, headers: :first_row) do |row|
        order = Order.find_payment_code_from_csv(row.to_s)
        # If the order doesn't exist
        unless order
          fails << row if order.nil?
          next
        end

        # if we can't read the amount of money, FAIL
        amount = row[paid].sub(',', '.')
        begin
          amount = Float(amount)
        rescue
          fails << row
          next
        end

        order.paid += amount
        order.payment_code = Order.create_payment_code
        order.save

        order.deliver

        counter += 1
      end

      success_msg = "Updated #{ActionController::Base.helpers.pluralize counter, 'payment'} successfully."
      if fails.any?
        flash.now[:success] = success_msg
        flash.now[:error] = 'The rows listed below contained an invalid code, please fix them by hand.'
        @csvheaders = fails.first.headers
        @csvfails = fails
        render 'upload'
      else
        flash[:success] = success_msg
        redirect_to action: :index
      end
    rescue CSV::MalformedCSVError
      flash[:error] = 'The file could not be parsed. Make sure that you uploaded the correct file and that the column seperator settings have been set to the correct seperator.'
      redirect_to action: :index
    end
  end
end
