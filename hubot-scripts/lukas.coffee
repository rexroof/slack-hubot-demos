# Description:
#   show me a lukas
#
# Commands:
#   hubot lukas me - show me a lukas
#
# Author:
#  rexroof

lukas_search = (msg) ->
  Flickr = require 'flickr-sdk'
  flickr = new Flickr(
    'apiKey': process.env.HUBOT_FLICKR_APIKEY
    'apiSecret': process.env.HUBOT_FLICKR_APISECRET )
  flickr.request().media().search('lukasmannroof').get().then (response) ->
    lp = msg.random response.body.photos.photo
    url = "https://c1.staticflickr.com/#{lp.farm}/#{lp.server}/#{lp.id}_#{lp.secret}_c.jpg"
    msg.send url
    return

module.exports = (robot) ->
  robot.respond /(lukas|lucas) ?m?e?.*/i, (msg) ->
    lukas_search(msg)
