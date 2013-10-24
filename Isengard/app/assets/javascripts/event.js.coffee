# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

ready = ->
  $('.edit_access_level > :checkbox').change ->
    $(this).parent().submit()

  #for bootstrap 3 use 'shown.bs.tab' instead of 'shown' in the next line
  $('a[data-toggle="tab"]').on "shown.bs.tab", (e) ->
    #save the latest tab; use cookies if you like 'em better:
    location.hash = $(e.target).attr('href').substr(1)
    localStorage.setItem "lastTab", location.hash


  #go to the latest tab, if it exists:
  lastTab = localStorage.getItem("lastTab")
  $('#myTab a[href='+lastTab+']').tab "show"  if lastTab

  # Fancy fields
  datePickerOptions = {
    autoclose: true,
    weekStart: 1,
    language: 'nl',
    startDate: $.format.date(Date(), "yyyy-MM-dd HH:mm")
  };

  $('#start').datetimepicker(datePickerOptions);
  $('#end').datetimepicker(datePickerOptions);

  # Adds Bootstrap error classes to all faulty fields
  $(".field_with_errors").parent().filter(".form-group").addClass("has-error");

$(document).ready(ready)
$(document).on('page:load', ready)

