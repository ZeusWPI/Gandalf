// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on('turbolinks:load', function() {

  // Manual registration locking
  $('#table-registrations').on('click', '.registration-lock', function() {
    const form = $(this).closest('form');
    if (form.find('.disabling').first().is(':disabled')) {
      form.find('.disabling').prop('disabled', false);
      form.find('.glyphicon').removeClass('glyphicon-lock');
      return form.find('.glyphicon').addClass('glyphicon-floppy-save');
    } else {
      return form.submit();
    }
  });

  // Using the checkbox to set the paid amount to the price (or zero)
  $('#table-registrations').on('change', '.registration-box', function() {
    const form = $(this).closest('form');
    if ($(this).is(':checked')) {
      return form.find('.registration-paid').val('0.00');
    } else {
      return form.find('.registration-paid').val(form.find('.registration-price').val());
    }
  });

  $("a[data-toggle = 'tooltip']").tooltip({'container': 'body'});

  $('th.to_pay').attr("width", 175);

  const hideCommentFieldIfNeeded = function(value) {
    const val = parseInt(value);
    if (window.ticketsWithComments && (window.ticketsWithComments.indexOf(val) === -1)) {
      return $("#registration_comment").parent().hide();
    } else {
      return $("#registration_comment").parent().show();
    }
  };

  const hidePaymentInfoIfNeeded = function(value) {
    const val = parseInt(value);
    if (window.freeTickets && (window.freeTickets.indexOf(val) !== -1)) {
      $("#payment-info").hide();
    } else {
      $("#payment-info").show();
    }
  };

  $("#registration_access_level").on('change', function() {
    hidePaymentInfoIfNeeded($(this).val());
    return hideCommentFieldIfNeeded($(this).val());
  });

  hidePaymentInfoIfNeeded($("#registration_access_level").val());
  return hideCommentFieldIfNeeded($("#registration_access_level").val());

});
