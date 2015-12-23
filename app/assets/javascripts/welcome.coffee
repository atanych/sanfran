SYNC_INTERVAL = 15000
# expression for url's validation
EXPRESSION = /[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}(\.[a-z]{2,4}\b)(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi
$(->
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
  # Validates url
  #
  validate = (url_name) ->
    regexp = EXPRESSION
    console.log(regexp.exec(url_name))
    a = url_name.match(EXPRESSION)
    console.log(a)
    return true

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


  urls = []
  unsync_urls = []
  do prepare
  $('#url-input').on 'keydown', (e) ->
    if e.keyCode == 13
      raw_url = $.trim($(this).val())
      if validate raw_url
        add_url(raw_url)
        $(this).val('')
      else
        console.log('novalid')

  #
  # for sync with server
  #
  window.setInterval(->
    sync(unsync_urls)
  , SYNC_INTERVAL)
)

