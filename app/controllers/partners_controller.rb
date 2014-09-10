class PartnersController < ApplicationController

  before_action :authenticate_user!, except: [:show, :confirm]
  #before_action :authenticate_partner!, only: [:show, :confirm]

  respond_to :html, :js

  def index
    @event = Event.find params.require(:event_id)

    authorize! :read, @event
  end

  def show
    @event = Event.find params.require(:event_id)
    @partner = @event.partners.find_by_id params.require(:id)

    # TODO uncomment after manual testing
    #authorize! :read, @partner
  end

  def new
    @partner = Partner.new
  end

  def create
    @event = Event.find params.require(:event_id)
    authorize! :update, @event

    @partner = @event.partners.new params.require(:partner).permit(:name, :email)
    @partner.access_level = al
    # TODO deliver? SHould be invitation...
    @partner.save

    respond_with @partner
  end

  def edit
    @event = Event.find params.require(:event_id)
    authorize! :update, @event

    @partner = @event.partners.find params.require(:id)
    respond_with @partner
  end

  def update
    @event = Event.find params.require(:event_id)
    authorize! :update, @event

    @partner = @event.partners.find params.require(:id)
    @partner.update params.require(:partner).permit(:name, :email)

    respond_with @partner
  end

  def destroy
    @event = Event.find params.require(:event_id)
    authorize! :update, @event

    @partner = @event.partners.find params.require(:id)
    @partner.destroy
  end

  def resend
    @event = Event.find params.require(:event_id)
    authorize! :read, @event

    partner = @event.partners.find params.require(:id)
    partner.deliver
  end

  # TODO remove access_level from the csv, or parse multiple lines and create an
  # invitation for each.
  def upload
    @event = Event.find params.require(:event_id)
    authorize! :update, @event

    headers = ['name', 'email', 'error']

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

      success_msg = "Added #{ActionController::Base.helpers.pluralize counter, "partners"} successfully."
      if fails.any?
        flash.now[:success] = success_msg unless counter == 0
        flash.now[:error] = "The rows listed below contained errors, please fix them by hand."
        @csvheaders = headers
        @csvfails = fails
        render 'upload'
      else
        flash[:success] = success_msg
        redirect_to action: :index
      end

    rescue CSV::MalformedCSVError
      flash[:error] = "The file could not be parsed. Make sure that you uploaded the correct file and that the column seperator settings have been set to the correct seperator."
      redirect_to action: :index
    rescue ActionController::ParameterMissing
      flash[:error] = "Please upload a CSV file."
      redirect_to action: :index
    end
  end

end
