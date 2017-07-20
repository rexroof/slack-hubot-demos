#robot Description:
#  an event emitter listener for posting a snippet
#  also creates a /snippet/ endpoint
#
# Dependencies:
#   none
#
# Author:
#   rexroof

post_snippet = (_filename, _content, _channel, _robot, _cb) ->
  upload_params =
    filename: _filename
    mode: 'snippet'
    type: 'auto'
    content: _content
    channels: _channel

  _robot.adapter.client.web.files.upload _filename, upload_params, (err, res) ->
    if (err)
      console.log "post_snippet #{_filename} erorr: #{err}"
    typeof _cb == 'function' and _cb(err, res)

module.exports = (robot) ->
  robot.on "post-snippet", (_filename, _content, _channel, _cb) ->
    post_snippet _filename, _content, _channel, robot, _cb

  robot.router.post '/snippet/:room', (req, res) ->
     room   = req.params.room
     data   = if req.body.payload? then JSON.parse req.body.payload else req.body
     filename = data.filename
     content = data.content
     _now = new Date()
     ip = req.headers['x-forwarded-for'] or
          req.connection.remoteAddress or
          req.socket.remoteAddress or
          req.connection.socket.remoteAddress
     robot.logger.info "#{_now} #{ip} #{req.headers.host}#{req.url} #{req.headers['user-agent']} message: #{req.body.message}"
     robot.emit "post-snippet", filename, content, room
     res.send 'OK'
