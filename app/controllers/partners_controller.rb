# frozen_string_literal: true

class PartnersController < ApplicationController
  include ActionView::Helpers::OutputSafetyHelper

  before_action :authenticate_user!, except: [:show, :confirm]
  before_action :authenticate_partner!, only: [:show, :confirm]

  respond_to :html, :js

  def index
    @event = Event.find params.require(:event_id)

    authorize! :read, @event
  end

  def show
    @event = Event.find params.require(:event_id)
    @partner = @event.partners.find_by(id: params.require(:id))

    authorize! :read, @partner
  end

  def new
    @partner = Partner.new
  end

  def edit
    @event = Event.find params.require(:event_id)
    authorize! :update, @event

    @partner = @event.partners.find params.require(:id)
    respond_with @partner
  end

  def create
    @event = Event.find params.require(:event_id)
    authorize! :update, @event

    al = @event.access_levels.find(partner_params[:access_level_id])
    @partner = @event.partners.new partner_params.merge(access_level: al)

    if @partner.save
      @partner.deliver
    else
      flash.now[:error] = "Something went wrong creating the partner"
    end

    respond_with @partner
  end

  def update
    @event = Event.find params.require(:event_id)
    authorize! :update, @event

    @partner = @event.partners.find params.require(:id)

    al = @event.access_levels.find(partner_params[:access_level_id])
    flash.now[:error] = "Something went wrong updating the partner" unless @partner.update(partner_params.merge(access_level: al))

    respond_with @partner
  end

  def destroy
    @event = Event.find params.require(:event_id)
    authorize! :update, @event

    @partner = @event.partners.find params.require(:id)
    @partner.destroy!
  end

  def resend
    @event = Event.find params.require(:event_id)
    authorize! :read, @event

    partner = @event.partners.find(params.require(:id))
    partner.deliver
  end

  def confirm
    @event = Event.find params.require(:event_id)
    @partner = @event.partners.find_by(id: params.require(:id))

    authorize! :register, @partner

    if @partner.confirmed
      flash.now[:error] = "You have already registered for this event. Please check your mailbox."
    else
      @registration = @event.registrations.new(
        email: @partner.email,
        name: @partner.name,
        student_number: nil,
        comment: nil,
        price: @partner.access_level.price,
        paid: 0,
        access_level: @partner.access_level
      )
      @partner.confirmed = true
      if @registration.save && @partner.save
        @registration.deliver
        flash.now[:success] = "Your invitation has been confirmed. Your ticket should arrive shortly."
      else
        flash.now[:error] = safe_join(
          "It looks like there already is someone with your name and/or email registered for this event. ",
          view_context.mail_to(@event.contact_email, 'Contact us'),
          " if this is not correct."
        )
      end
    end
  end

  def upload
    @event = Event.find params.require(:event_id)
    authorize! :update, @event

    headers = %w[name email error]

    sep = params.require(:upload).require(:separator)
    al = @event.access_levels.find params.require(:upload).require(:access_level)

    fails = []
    counter = 0

    begin
      CSV.parse(params.require(:upload).require(:csv_file).read, col_sep: sep, headers: headers) do |row|
        p = @event.partners.new
        p.name = row[0]
        p.email = row[1]
        p.access_level = al

        if p.save
          p.deliver
        else
          row['error'] = p.errors.full_messages.join(', ')
          fails << row
          next
        end

        counter += 1
      end

      success_msg = "Added #{ActionController::Base.helpers.pluralize counter, 'partners'} successfully."
      if fails.any?
        flash.now[:success] = success_msg unless counter.zero?
        flash.now[:error] = "The rows listed below contained errors, please fix them by hand."
        @csvheaders = headers
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
    rescue ActionController::ParameterMissing
      flash[:error] = "Please upload a CSV file."
      redirect_to action: :index
    end
  end

  private

  def partner_params
    params.require(:partner).permit(:name, :email, :access_level_id)
  end
end
