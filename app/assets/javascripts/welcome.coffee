SYNC_INTERVAL = 3500

$(->

  #
  # Adds url
  #
  add_url = (url_name) ->
    unsync_urls.push url_name
    $('#url-container').prepend('<div>' + url_name + '</div>')

  #
  # Validates url
  #
  validate = (url_name) ->
    return true

  #
  # Syncs client data with server
  #
  sync = () ->
    console.log('sync', unsync_urls)
    $.ajax
      method: 'POST'
      url: 'welcome/sync'
      data:
        urls: unsync_urls
      success: (res) ->
        if res.status == 'ok'
          unsync_urls.splice(0,unsync_urls.length)


  unsync_urls = []

  $('#url-input').on 'keydown', (e) ->
    if e.keyCode == 13
      raw_url = $(this).val()
      if validate raw_url
        add_url(raw_url)
        $(this).val('')

  window.setInterval(->
    sync(unsync_urls)
  , SYNC_INTERVAL)
)

