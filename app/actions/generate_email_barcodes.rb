require 'barby/barcode/ean_13'
require 'barby/outputter/png_outputter'
require 'chunky_png'

class GenerateEmailBarcodes

  def initialize(barcode_data)
    @barcode_data = barcode_data
  end

  def call
    barcode = Barby::EAN13.new(@barcode_data)

    png_outputter = Barby::PngOutputter.new(barcode)
    png_outputter.xdim = 2
    png_outputter.ydim = 1

    barcode_canvas = png_outputter.to_image

    image = barcode_canvas.to_blob
    tilted_image = barcode_canvas.rotate_right.to_blob

    [image, tilted_image]
  end
end
