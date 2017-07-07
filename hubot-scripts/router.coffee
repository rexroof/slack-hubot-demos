# This creates an endpoint on our hubot process that can receive http POST requests
# at /say/channel and post messages on slack.
#
module.exports = (robot) ->
  robot.router.post '/say/:channel', (req,res) ->
    channel = req.params.room
    # decode our json data
    data    = if req.body.payload? then JSON.parse req.body.payload else req.body
    message = data.message
    # these are all the places we might find an originating IP
    ip = req.headers['x-forwarded-for'] or
         req.connection.remoteAddress or
         req.socket.remoteAddress or
         req.connection.socket.remoteAddress
    _now = new Date()
    # send an access log
    robot.logger.info "#{_now} #{ip} #{req.headers.host}#{req.url} #{req.headers['user-agent']} message: #{req.body.message}"
    # post our message to the room
    robot.messageRoom channel, message
    # send an OK response back to the http client
    res.send 'OK'
