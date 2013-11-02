# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

ready = ->
  $('.edit_access_level > :checkbox').change ->
    $(this).parent().submit()

  # Fancy fields
  datePickerOptions = {
    autoclose: true,
    weekStart: 1,
    language: 'nl',
    startDate: $.format.date(Date(), "yyyy-MM-dd HH:mm")
  }

  $('#start').datetimepicker(datePickerOptions)
  $('#end').datetimepicker(datePickerOptions)
  $('#registration-start').datetimepicker(datePickerOptions)
  $('#registration-end').datetimepicker(datePickerOptions)

  # Manual registration locking
  $('.registration-lock').click ->
    form = $(this).closest('form')
    if form.find('.disabling').first().is(':disabled')
      form.find('.disabling').prop('disabled', false)
      form.find('.glyphicon').removeClass('glyphicon-lock')
      form.find('.glyphicon').addClass('glyphicon-floppy-save')
    else
      form.submit()
      form.find('.disabling').prop('disabled', true)
      form.find('.glyphicon').addClass('glyphicon-lock')
      form.find('.glyphicon').addClass('glyphicon-lock')
      form.find('.glyphicon').removeClass('glyphicon-floppy-save')

  # Using the checkbox to set the paid amount to the price (or zero)
  $('.registration-box').change ->
    form = $(this).closest('form')
    if $(this).is(':checked')
      form.find('.registration-paid').val(form.find('.registration-price').val())
    else
      form.find('.registration-paid').val(0)

  # Adds Bootstrap error classes to all faulty fields
  $(".field_with_errors").parent().filter(".form-group").addClass("has-error")

  if window.location.hash
    $("a[data-toggle=tab][href="+window.location.hash+"]").tab('show')

  $("#delete-confirm").on "show.bs.modal", ->
    $submit = $(this).find(".btn-danger")
    $submit.attr "href", $(this).data("link")

  $(".delete-confirm").click (e) ->
    e.preventDefault()
    $("#delete-confirm").data("link", $(this).data("link")).modal "show"


$(document).ready(ready)
$(document).on('page:load', ready)
