# frozen_string_literal: true

require 'barby/barcode/qr_code'
require 'barby/outputter/png_outputter'
require 'chunky_png'

class GenerateEmailEpcQr
  def initialize(epc_data)
    @epc_data = epc_data
  end

  def call
    qrcode = Barby::QrCode.new(epc_data)

    png_outputter = Barby::PngOutputter.new(qrcode)
    png_outputter.xdim = 4
    png_outputter.ydim = 4

    qrcode_canvas = png_outputter.to_image
    qrcode_canvas.to_blob
  end
end
