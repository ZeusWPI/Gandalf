module ApplicationHelper
  # Prettify helpers
  def nice_time(f)
    f.try { |d| d.strftime('%a %d %b %Y %H:%M') }
  end

  def datepicker_time(f)
    f.try { |d| d.strftime('%Y-%m-%d %H:%M') }
  end

  def euro(f)
    "&euro;#{number_with_precision f, precision: 2}"
  end

  # Form helpers
  def form_errors(object)
    render partial: 'form_errors', locals: { object: object }
  end

  def form_text_field(f, tag)
    render partial: 'form_text_field', locals: { f: f, tag: tag }
  end

  def form_url_field(f, tag)
    render partial: 'form_url_field', locals: { f: f, tag: tag }
  end

  def form_text_area(f, tag)
    render partial: 'form_text_area', locals: { f: f, tag: tag }
  end

  def form_fancy_text_area(f, tag)
    render partial: 'form_fancy_text_area', locals: { f: f, tag: tag }
  end

  def form_email_field(f, tag)
    render partial: 'form_email_field', locals: { f: f, tag: tag }
  end

  def form_date_field(f, tag, id, value)
    render partial: 'form_date_field', locals: { f: f, tag: tag, id: id, value: value }
  end

  def form_number_field(f, tag)
    render partial: 'form_number_field', locals: { f: f, tag: tag }
  end

  def form_collection_select(f, *args)
    # This line enable passing optional arguments such as include_blank to the
    # partial. If nothing is passed, an empty options hash is appended.
    args << {} if args.length < 5

    render partial: 'form_collection_select', locals: { f: f, args: args }
  end

  def form_check_box(f, tag)
    render partial: 'form_check_box', locals: { f: f, tag: tag }
  end

  # Pagination
  def bootstrap_pagination(collection)
    render partial: 'bootstrap_pagination', locals: { collection: collection }
  end
end
