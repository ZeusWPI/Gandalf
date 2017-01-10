class UnsubscribeController < ApplicationController
  def show
    @registration = Registration.find_by! id: params[:id], barcode: params[:barcode]
  end

  def delete
    @registration = Registration.find_by! id: params[:id], barcode: params[:barcode]

  end
end
