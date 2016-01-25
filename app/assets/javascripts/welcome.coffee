class UrlHandler

  SYNC_INTERVAL: 15000 # interval for sync with server

  KEYBOARD_ENTER_CODE: 13 # code for button 'Enter'

  SYNC_URL: 'welcome/sync' # url to syncronize

  # expression for url's validation
  # todo my expession isn't good :(
  EXPRESSION: ///^
  ((http|ftp|https):\/{2})? # protocol
  (www.)? # www
  ([-a-zA-Z]{1}[-a-zA-Z0-9@%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b) # domain
  (\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)? # uri with query
  $ ///i


  constructor: () ->
    @urls = []
    @unsync_urls = []
    do @handlers
    do @collect

  #
  # Set handlers for events and timers
  #
  handlers: ->
    $('#url-input').on 'keydown', (e) =>
      if e.keyCode == @KEYBOARD_ENTER_CODE
        raw_url = $.trim($(e.target).val())
        if @add(raw_url)
          $(e.target).val('')
        else
          throw new Error("url #{raw_url} no valid");

    window.setInterval(=>
      do @sync
    , @SYNC_INTERVAL)


  #
  # Collect data from server
  #
  collect: ->
    $('#url-container div').each (a, v) =>
      @urls.unshift($.trim($(v).text()))

  #
  # Add url
  #
  # @param [String] url
  #
  add: (url) ->
    if @validate(url)
      url = @parse(url)
      @urls.push url
      @unsync_urls.push url
      $('#url-container').prepend('<div>' + url + '</div>')
      true
    else
      false

  #
  # Validate url
  #
  # @param [String] url
  #
  validate: (url) ->
    !!url.match(@EXPRESSION)

  #
  # Parse row url
  #
  # @param [String] url
  #
  # @return [String] domain name
  #
  parse: (url) ->
    matches = url.match(@EXPRESSION)
    if matches && matches[4]
      matches[4]

  #
  # Sync client data with server
  #
  sync: ->
    $.ajax
      method: 'POST'
      url: @SYNC_URL
      data:
        urls: @unsync_urls
      success: (res) =>
        if res.status == 'ok'
          @unsync_urls.splice(0, @unsync_urls.length)



$(->
  new UrlHandler
)