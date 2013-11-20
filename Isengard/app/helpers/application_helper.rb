module ApplicationHelper

  def nice_time(f)
    f.try { |d| d.strftime("%a %d %b %Y %H:%M") }
  end

  def datepicker_time(f)
    f.try { |d| d.strftime("%Y-%m-%d %H:%M") }
  end

  def form_errors(object)
    render partial: "form_errors", locals: {object: object}
  end

  def form_text_field(f, tag)
    render partial: "form_text_field", locals: {f: f, tag: tag}
  end

  def form_text_area(f, tag)
    render partial: "form_text_area", locals: {f: f, tag: tag}
  end

  def form_fancy_text_area(f, tag)
    render partial: "form_fancy_text_area", locals: {f: f, tag: tag}
  end

  def form_email_field(f, tag)
    render partial: "form_email_field", locals: {f: f, tag: tag}
  end

  def form_date_field(f, tag, id, value)
    render partial: "form_date_field", locals: {f: f, tag: tag, id: id, value: value}
  end

  def form_number_field(f, tag)
    render partial: "form_number_field", locals: {f: f, tag: tag}
  end

  def form_simple_select(f, tag, map)
    render partial: "form_simple_select", locals: {f: f, tag: tag, map: map}
  end

  def form_collection_select(f, *args)
    render partial: "form_collection_select", locals: {f: f, args: args}
  end

  def form_check_box(f, tag)
    render partial: "form_check_box", locals: {f: f, tag: tag}
  end

  def bootstrap_pagination(collection)
    render partial: "bootstrap_pagination", locals: {collection: collection}
  end
end
