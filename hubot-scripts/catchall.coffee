# Description:
#   send catchall responses to wolfram alpha
#   based on code found in the old hubot-script repo
#
# Dependencies:
#   "wolfram": "0.2.2"
#
# Configuration:
#   HUBOT_WOLFRAM_APPID - your AppID
#
# Commands:
#   hubot [question] - search Wolfram Alpha for the answer to the question
#
# Notes:
#   This may not work with node 0.6.x
#
# Author:
#   dhorrigan, rexroof

Util = require('util')
Wolfram = require('wolfram').createClient(process.env.HUBOT_WOLFRAM_APPID)

not_found = (msg) ->
  msg.reply msg.random [
    'hmm.  not sure.',
    'no search results found',
    "can't figure that one out",
    'you should google that one',
    'I am coming up short',
    'beats me',
    'that is outside of my parameters',
    'no idea',
    'wish I knew!',
    'not a clue'
  ]

# process wolfram request
wolfram_me = (input_query, msg) ->
  console.log "got query: #{input_query}"
  Wolfram.query input_query, (e, result) ->
    if result and result.length > 0
      first_result = result[1]['subpods'][0]
      if first_result['value']
        msg.reply first_result['value']
      else if first_result['image']
        msg.reply first_result['image']
      else
        not_found(msg)
    else
      not_found(msg)

module.exports = (robot) ->
  # catchall to send everything not caught to wolfram
  robot.catchAll (msg) ->
    # pattern to strip robot's name from query
    r = new RegExp "^(?:#{robot.alias}|#{robot.name}):? ?(.*)", "i"
    matches = msg.message.text.match(r)
    if matches != null && matches.length > 1
      wolfram_me(matches[1], msg)
    msg.finish()
