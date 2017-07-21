#robot Description:
#   tools for posting and updating/refreshing a message
#   creates update-message event listener and /status-post/ endpoint
#
# Dependencies:
#   none
#
# Author:
#   rexroof

module.exports = (robot) ->
  remembered_messages = () -> robot.brain.data.remembered_messages ?= {}

  # robot.emit "update-message", "new_test_key", msg.message.user.room, "I've said something"
  robot.on "update-message", (_tag, _channel, _text, _cb) ->
    # if we have a remembered message with this tag, just try and update that.
    if remembered_messages()[_tag]?
      response_object = remembered_messages()[_tag]
      rhandle = response_object[0]._rejectionHandler0
      robot.adapter.client.web.chat.update rhandle.ts, rhandle.channel, _text, (err,res) ->
        if (err)
          console.log "chat update #{err}"
        typeof _cb == 'function' and _cb(err, res)
    # otherwise, we're posting new
    else
      remembered_messages()[_tag] = robot.send room: _channel, _text
      typeof _cb == 'function' and _cb(err, res)

   robot.router.post '/status-post/:msgkey', (req, res) ->
     msgkey  = req.params.msgkey
     data    = if req.body.payload? then JSON.parse req.body.payload else req.body
     message = data.message
     channel = data.channel
     _now = new Date()

     console.log "#{msgkey} #{channel} #{message} #{Util.inspect data, {depth: null}}"
     ip = req.headers['x-forwarded-for'] or
          req.connection.remoteAddress or
          req.socket.remoteAddress or
          req.connection.socket.remoteAddress
     robot.logger.info "#{_now} #{ip} #{req.headers.host}#{req.url} #{req.headers['user-agent']} message: #{req.body.message}"
     robot.emit "update-message", msgkey, channel, message
     res.send 'OK'
