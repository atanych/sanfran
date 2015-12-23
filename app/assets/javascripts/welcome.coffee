# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(->

  #
  # Adds url
  #
  add_url = (url_name) ->
    $('#url-container').append('<div>' + url_name + '</div>')

  #
  # Validates url
  #
  validate = (url_name) ->
    return true

  $('#url-input').on 'keydown', (e) ->
    if e.keyCode == 13
      raw_url = $(this).val()
      if validate raw_url
        add_url(raw_url)
        $(this).val('')
)

