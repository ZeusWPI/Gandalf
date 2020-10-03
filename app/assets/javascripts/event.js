// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('turbolinks:load', function () {

  $('.edit_access_level > :checkbox').change(function () {
    return $(this).parent().submit();
  });

  var datePickerOptions = {
    autoclose: true,
    weekStart: 1,
    language: 'nl',
    startDate: $.format.date(Date(), "yyyy-MM-dd HH:mm")
  };

  $('#start').datetimepicker(datePickerOptions);
  $('#end').datetimepicker(datePickerOptions);

  $('#registration-start').datetimepicker(datePickerOptions);
  $('#registration-end').datetimepicker(datePickerOptions);

  $(".field_with_errors").parent().filter(".form-group").addClass("has-error");

  $("#delete-confirm").on("show.bs.modal", function () {
    var $submit;
    $submit = $(this).find(".btn-danger");
    return $submit.attr("href", $(this).data("link"));
  });

  return $(".delete-confirm").click(function (e) {
    e.preventDefault();
    return $("#delete-confirm").data("link", $(this).data("link")).modal("show");
  });
});
