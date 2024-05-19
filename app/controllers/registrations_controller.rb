# frozen_string_literal: true

class RegistrationsController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create, :show]

  require 'csv'

  respond_to :html, :js

  def index
    @event = Event.find params.require(:event_id)

    authorize! :read, @event

    @registrationsgrid = RegistrationsGrid.new(params[:registrations_grid]) do |scope|
      scope.where(event_id: @event.id).order(Arel.sql("registrations.price - paid DESC"))
    end

    @registrations = @registrationsgrid.assets
    @registrations = @registrations.paginate(page: params[:page], per_page: 25)
  end

  def show
    @registration = Registration.find_by(token: params[:token])
    return head(:not_found) unless @registration

    @event = @registration.event
    @barcode = GenerateHtmlBarcodes.new(@registration.barcode_data).call
    @qr_code = GenerateEpcQr.new(@registration.epc_data).call
  end

  def new
    @event = Event.find params.require(:event_id)
    @registration = Registration.new
  end

  def create
    @event = Event.find params.require(:event_id)

    # Check if the user can register
    authorize! :register, @event
    requested_access_level = @event.access_levels.find(params.require(:registration).require(:access_level))
    authorize! :register, requested_access_level

    # Make the registration
    @registration = @event.registrations.new params.require(:registration).permit(:email, :name, :student_number, :comment)
    @registration.access_level = requested_access_level
    @registration.price = requested_access_level.price
    @registration.paid = 0

    # overwrite student_number so setting this will not work
    @registration.student_number = current_user.cas_ugentstudentid if requested_access_level.requires_login?

    # Send the confirmation email.
    if @registration.save
      @registration.deliver

      flash[:success] = "Registration successful. Please check your mailbox for your ticket or further payment information."

      redirect_to event_registration_path(@registration.event, @registration.token)
    else
      render "events/show"
    end
  end

  def update
    @registration = Registration.find params.require(:id)
    authorize! :update, @registration

    paid = @registration.paid
    @registration.update! params.require(:registration).permit(:to_pay)
    @registration.deliver if @registration.paid != paid

    respond_with @registration
  end

  def destroy
    @event = Event.find params.require(:event_id)
    authorize! :destroy, @event
    registration = Registration.find params.require(:id)
    @id = registration.id
    registration.destroy!
  end

  def info
    @registration = Registration.find params.require(:id)
    authorize! :read, @registration.event
  end

  def resend
    @registration = Registration.find params.require(:id)
    authorize! :update, @registration.event
    @registration.deliver
  end

  def email
    @event = Event.find params.require(:event_id)
    authorize! :read, @event
    to_id = params['to'].to_i
    to = to_id == -1 ? @event.registrations.pluck(:email) : @event.access_levels.find(to_id).registrations.pluck(:email)
    MassMailer.general_message(@event.contact_email, to, params['email']['subject'], params['email']['body']).deliver_later
    redirect_to event_registrations_path(@event)
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
        registration = Registration.find_payment_code_from_csv(row.to_s)
        # If the registration doesn't exist
        unless registration
          fails << row if registration.nil?
          next
        end

        # if we can't read the amount of money, FAIL
        amount = row[paid].sub(',', '.')
        begin
          amount = Float(amount)
        rescue StandardError
          fails << row
          next
        end

        registration.paid += amount
        registration.payment_code = Registration.create_payment_code
        registration.save!

        registration.deliver

        counter += 1
      end

      success_msg = "Updated #{ActionController::Base.helpers.pluralize counter, 'payment'} successfully."
      if fails.any?
        flash.now[:success] = success_msg
        flash.now[:error] = "The rows listed below contained an invalid code, please fix them by hand."
        @csvheaders = fails.first.headers
        @csvfails = fails
        render 'upload'
      else
        flash[:success] = success_msg
        redirect_to action: :index
      end
    rescue CSV::MalformedCSVError
      flash[:error] = %( The file could not be parsed. Make sure that you uploaded the correct file
        and that the column separator settings have been set to the correct separator. ).squish
      redirect_to action: :index
    end
  end
end
