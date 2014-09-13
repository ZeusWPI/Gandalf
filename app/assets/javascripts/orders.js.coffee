# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->

  # Manual order locking
  $('#table-orders').on 'click', '.order-lock', ->
    form = $(this).closest('form')
    if form.find('.disabling').first().is(':disabled')
      form.find('.disabling').prop('disabled', false)
      form.find('.glyphicon').removeClass('glyphicon-lock')
      form.find('.glyphicon').addClass('glyphicon-floppy-save')
    else
      form.submit()

  # Using the checkbox to set the paid amount to the price (or zero)
  $('#table-orders').on 'change', '.order-box', ->
    form = $(this).closest('form')
    if $(this).is(':checked')
      form.find('.order-paid').val('0.00')
    else
      form.find('.order-paid').val(form.find('.order-price').val())

  $("a[data-toggle = 'tooltip']").tooltip({'container': 'body'})

  $('th.to_pay').attr("width", 175)

  $('.btn-inc').on 'click', ->
    input = $(this).parent().parent().find('input').first()
    input.val(parseInt(input.val()) + 1)

  $('.btn-dec').on 'click', ->
    input = $(this).parent().parent().find('input').first()
    if input.val() != '0'
      input.val(parseInt(input.val()) - 1)

  $('#order_email').on 'change', ->
    $('#order_email_confirmation').val('')

  $('#order_email_confirmation').val($('#order_email').val())


$(document).ready(ready)
$(document).on('page:load', ready)
