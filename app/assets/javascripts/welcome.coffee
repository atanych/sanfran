# interval for sync with server
SYNC_INTERVAL = 15000

# expression for url's validation
# todo my expession isn't good :( i
EXPRESSION = /^((http|ftp|https):\/{2})?(www.)?([-a-zA-Z0-9@%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b)(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?$/gi
$(->

  # -----------------------------------------------
  # METHODS
  # ------------------------------------------------

  #
  # Adds url
  #
  add_url = (url_name) ->
    if $.inArray(url_name, urls) == -1
      urls.push url_name
      unsync_urls.push url_name
      $('#url-container').prepend('<div>' + url_name + '</div>')
    else
      throw new Error('duplicate')

  #
  # Validates and parse row url (returns domain name)
  #
  validate_and_parse = (url_name) ->
    regexp = new RegExp(EXPRESSION)
    matches = regexp.exec(url_name)
    if matches && matches[4]
      return matches[4]
    else
      return false

  #
  # Syncs client data with server
  #
  sync = () ->
    $.ajax
      method: 'POST'
      url: 'welcome/sync'
      data:
        urls: unsync_urls
      success: (res) ->
        if res.status == 'ok'
          unsync_urls.splice(0, unsync_urls.length)

  #
  # Prepares data
  #
  prepare = ->
    $('#url-container div').each (a, v) ->
      urls.unshift($.trim($(v).text()))


  # -----------------------------------------------
  # INIT
  # ------------------------------------------------
  urls = []
  unsync_urls = []
  do prepare

  # -----------------------------------------------
  # HANDLERS
  # ------------------------------------------------
  $('#url-input').on 'keydown', (e) ->
    if e.keyCode == 13
      raw_url = $.trim($(this).val())
      if url = validate_and_parse raw_url
        add_url(url)
        $(this).val('')
      else
        console.log('novalid')

  window.setInterval(->
    sync(unsync_urls)
  , SYNC_INTERVAL)
)

