app.controller 'IndexController',
  class IndexController
    constructor: (@$filter, @Socket, @HtmlHelper) ->
      @has_error = false
      @username = ''
      @clist = []
      @messages = []
      @Socket.on 'msg', (data) =>
        @messages.push new Message(
          $filter('date')(data.timestamp, 'HH:mm:ss')
          data.user
          $filter('emoticons')(data.payload)
        )
      @Socket.on 'connect', () =>
        @has_error = false
      @Socket.on 'connect_error', (e) =>
        @has_error = true
      @Socket.on 'new username', (name) =>
        @username = name
      @Socket.on 'clist changed', (clist) =>
        @clist = clist
      @Socket.on 'announce:join', (data) =>
        @messages.push new Message(
          $filter('date')(data.timestamp, 'HH:mm:ss')
          data.user
          "#{ data.payload } joined the conversation."
          'announcement'
        )
      @Socket.on 'announce:leave', (data) =>
        @messages.push new Message(
          $filter('date')(data.timestamp, 'HH:mm:ss')
          data.user
          "#{ data.payload } left the conversation."
          'announcement'
        )
    send: () ->
      @Socket.emit 'msg', new Message(
        null
        @username
        @HtmlHelper.htmlEntities @currentPayload
      )
      delete @currentPayload
