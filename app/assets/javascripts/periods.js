// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on('turbolinks:load', function() {

  // Fancy fields
  const datePickerOptions = {
    autoclose: true,
    weekStart: 1,
    language: 'nl',
    startDate: $.format.date(Date(), "yyyy-MM-dd HH:mm")
  };

  const dayPickerOptions = {
    autoclose: true,
    weekStart: 1,
    language: 'nl',
    startDate: $.format.date(Date(), "yyyy-MM-dd"),
    format: 'yyyy-mm-dd'
  };

  $('#period-start').datetimepicker(datePickerOptions);
  $('#period-end').datetimepicker(datePickerOptions);

  $('#new_period :checkbox').change(function() {
    if ($(this).is(':checked')) {
      $('#period-start').datetimepicker("remove");
      $('#period-end').datetimepicker("remove");
      $('#period-start').datepicker(dayPickerOptions);
      return $('#period-end').datepicker(dayPickerOptions);
    } else {
      $('#period-start').datepicker("remove");
      $('#period-end').datepicker("remove");
      $('#period-start').datetimepicker(datePickerOptions);
      return $('#period-end').datetimepicker(datePickerOptions);
    }
  });


  // Adds Bootstrap error classes to all faulty fields
  return $(".field_with_errors").parent().filter(".form-group").addClass("has-error");
});
