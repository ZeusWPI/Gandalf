# frozen_string_literal: true

require 'barby/barcode/qr_code'
require 'barby/outputter/png_outputter'
require 'chunky_png'

class GenerateEpcQr
  def initialize(registration)
    @registration = registration
  end

  def call
    qrcode = Barby::QrCode.new(epc_from_registration)

    png_outputter = Barby::PngOutputter.new(qrcode)
    png_outputter.xdim = 4
    png_outputter.ydim = 4

    barcode_canvas = png_outputter.to_image

    barcode_canvas.to_blob
  end

  def epc_from_registration
    <<~HEREDOC
      BCD
      002
      1
      SCT

      #{@registration.event.club.name}
      #{@registration.event.bank_number}
      EUR#{format '%.2f', @registration.to_pay}


      #{@registration.payment_code}

    HEREDOC
  end
end
