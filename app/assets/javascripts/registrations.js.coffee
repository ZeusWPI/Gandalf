# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->

  # Manual registration locking
  $('#table-registrations').on 'click', '.registration-lock', ->
    form = $(this).closest('form')
    if form.find('.disabling').first().is(':disabled')
      form.find('.disabling').prop('disabled', false)
      form.find('.glyphicon').removeClass('glyphicon-lock')
      form.find('.glyphicon').addClass('glyphicon-floppy-save')
    else
      form.submit()

  # Using the checkbox to set the paid amount to the price (or zero)
  $('#table-registrations').on 'change', '.registration-box', ->
    form = $(this).closest('form')
    if $(this).is(':checked')
      form.find('.registration-paid').val('0.00')
    else
      form.find('.registration-paid').val(form.find('.registration-price').val())

  hideCommentFieldIfNeeded = (value) ->
    val = parseInt(value)
    if (window.ticketsWithComments.indexOf(val) == -1)
      $("#registration_comment").parent().hide();
    else
      $("#registration_comment").parent().show();

  $("#registration_access_levels").on 'change', ->
    hideCommentFieldIfNeeded($(this).val())

  hideCommentFieldIfNeeded($("#registration_access_levels").val())


$(document).ready(ready)
$(document).on('page:load', ready)
