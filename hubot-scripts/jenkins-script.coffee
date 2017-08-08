# Description:
#   creates event handler to start jenkins scripts
#
# Dependencies:
#   "querystring"
#   "http-status"
#
# Configuration:
#   HUBOT_JENKINS_URL - url to your jenkins server
#   HUBOT_JENKINS_AUTH - set to "user:pass" for your jenkins server
#
# Commands:
#
# Notes:
#
# Author:
#   rexroof

_qs = require 'querystring'
_hs = require 'http-status'

jenkinsScript = ( script, params, msg ) ->
  if process.env.HUBOT_JENKINS_URL
    url = process.env.HUBOT_JENKINS_URL
  else
    msg.reply "HUBOT_JENKINS_URL is not set"
    return
  url += "/job/jenkins-script/buildWithParameters?"
  params.SK_CHANNEL = msg.message.room
  params.SK_REPLY = msg.message.user.name
  query_params =
    JENK_SCRIPT: script
    JSON_OPTIONS: new Buffer(JSON.stringify(params)).toString('base64')
  url += ("#{_qs.escape k}=#{_qs.escape v}" for k,v of query_params).join('&')

  request = msg.http(url)
  if process.env.HUBOT_JENKINS_AUTH
    auth = new Buffer(process.env.HUBOT_JENKINS_AUTH).toString('base64')
    request.headers Authorization: "Basic #{auth}"
  request.header('Content-Length', 0)
  request.post() (err,res,body) ->
    if err
      msg.reply "Jenkins error: #{err}"
    else
      msg.reply "request jenkins-script: #{script} sent to jenkins (status #{res.statusCode} #{_hs[res.statusCode]})"
      

module.exports = (robot) ->
  # you can use this in other scripts with 
  #   robot.emit "jenkins-script", "scriptname.sh", parameters, msg
  #   note if 'robot' is out of scope you can also use msg.robot.emit
  robot.on "jenkins-script", (_script, _params, _msg) ->
    jenkinsScript(_script, _params, _msg)
