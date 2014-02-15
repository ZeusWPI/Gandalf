class RegistrationsController < ApplicationController

  before_action :authenticate_user!, only: [:index, :destroy, :resend, :update, :email, :upload]

  require 'csv'

  respond_to :html, :js

  def index
    @event = Event.find params.require(:event_id)

    authorize! :read, @event

    @registrationsgrid = RegistrationsGrid.new(params[:registrations_grid]) do |scope|
      scope.where(event_id: @event.id).order("registrations.price - paid DESC")
    end

    @registrations = @registrationsgrid.assets
    @registrations = @registrations.paginate(page: params[:page], per_page: 25)
  end

  def new
    @event = Event.find params.require(:event_id)
    @registration = Registration.new
  end

  def destroy
    @event = Event.find params.require(:event_id)
    authorize! :destroy, @event
    registration = Registration.find params.require(:id)
    @id = registration.id
    registration.destroy
  end

  def info
    @registration = Registration.find params.require(:id)
    authorize! :read, @registration.event
  end

  def resend
    @registration = Registration.find params.require(:id)
    authorize! :update, @registration.event
    if @registration.is_paid
      RegistrationMailer.ticket(@registration).deliver
    else
      RegistrationMailer.confirm_registration(@registration).deliver
    end
  end

  def basic
    @event = Event.find params.require(:event_id)

    # Check if the user can register
    authorize! :register, @event
    requested_access_level = @event.access_levels.find(params.require(:registration).require(:access_levels))
    authorize! :register, requested_access_level

    # Make the registration
    @registration = @event.registrations.create params.require(:registration).permit(:email, :name, :student_number, :comment)
    @registration.access_levels << requested_access_level
    @registration.update paid: 0, price: requested_access_level.price

    # Send the confirmation email.
    if not @registration.errors.any?
      @registration.generate_barcode

      if @registration.is_paid
        RegistrationMailer.ticket(@registration).deliver
      else
        RegistrationMailer.confirm_registration(@registration).deliver
      end

      flash[:success] = "Registration successful. Please check your mailbox for your ticket or further payment information."
      respond_with @event
    else
      render "events/show"
    end
  end

  def advanced
    # TODO can can
    @event = Event.find params.require(:event_id)
    @registration = @event.registrations.create params.require(:registration).permit(:email, :name)
    params.require(:registration).require(:checkboxes).each do |access_level, periods|
      periods.each do |period, checked|
        if checked == "on" then
          access = @registration.accesses.build access_level_id: access_level, period_id: period
          access.save
        end
      end
    end
  end

  def update
    @registration = Registration.find params.require(:id)
    authorize! :update, @registration
    @registration.update params.require(:registration).permit(:to_pay)
    if @registration.is_paid
      RegistrationMailer.ticket(@registration).deliver
      if @registration.paid > @registration.price
        RegistrationMailer.notify_overpayment(@registration).deliver
      end
    else
      RegistrationMailer.confirm_registration(@registration).deliver
    end
    respond_with @registration
  end

  def email
    @event = Event.find params.require(:event_id)
    authorize! :read, @event
    to_id = params['to'].to_i
    if to_id == -1
      to = @event.registrations.pluck(:email)
    else
      to = @event.access_levels.find_by_id(to_id).registrations.pluck(:email)
    end
    MassMailer.general_message(@event.contact_email, to, params['email']['subject'], params['email']['body']).deliver
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
        match = /GAN(?<event_id>\d+)D(?<id>\d+)A(?<sum>\d+)L(?<ssum>\d+)F(?<rand>\d+)/.match(row.to_s)
        next unless match # seems like this is not a Gandalf transfer.

        registration = @event.registrations.find_by_id match[:id]

        # If the registration doesn't exist
        if registration.nil?
          fails << row
          next
        end

        # if it's not a real code, FAIL
        unless registration.payment_code == match.to_s
          fails << row
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

        registration.paid += amount
        registration.save

        if registration.is_paid
          RegistrationMailer.ticket(registration).deliver
        else
          RegistrationMailer.confirm_registration(registration).deliver
        end

        counter += 1
      end

      flash.now[:success] = "Updated #{ActionController::Base.helpers.pluralize counter, "payment"} successfully."
      if fails.any?
        flash.now[:error] = "The rows listed below contained an invalid code, please fix them by hand."
        @csvheaders = fails.first.headers
        @csvfails = fails
        render 'upload'
      else
        @registrations = @event.registrations.all.sort_by {:to_pay }.reverse.paginate(page: params[:page], per_page: 15)
        render 'index'
      end
    rescue CSV::MalformedCSVError
      flash.now[:error] = "The file could not be parsed. Make sure that you uploaded the correct file and that the column seperator settings have been set to the correct seperator."
      @registrations = @event.registrations.all.sort_by {:to_pay }.reverse.paginate(page: params[:page], per_page: 15)
      render 'index'
    end

  end

end
