# frozen_string_literal: true

require 'barby/barcode/ean_13'
require 'barby/outputter/html_outputter'

class GenerateHtmlBarcodes
  def initialize(barcode_data)
    @barcode_data = barcode_data
  end

  def call
    barcode = Barby::EAN13.new(@barcode_data)

    html_outputter = Barby::HtmlOutputter.new(barcode)
    html_outputter.to_html.html_safe # rubocop:disable Rails/OutputSafety
  end
end
