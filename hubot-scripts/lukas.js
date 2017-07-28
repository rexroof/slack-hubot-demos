// Description:
//   show me a lukas
//
// Commands:
//   hubot lukas me - show me a lukas
//
// Author:
//  rexroof
const lukas_search = function(msg) {
  const Flickr = require('flickr-sdk');
  const flickr = new Flickr({
    'apiKey': process.env.HUBOT_FLICKR_APIKEY,
    'apiSecret': process.env.HUBOT_FLICKR_APISECRET });
  flickr.request().media().search('lukasmannroof').get().then(function(response) {
    const lp = msg.random(response.body.photos.photo);
    const url = `https://c1.staticflickr.com/${lp.farm}/${lp.server}/${lp.id}_${lp.secret}_c.jpg`;
    msg.send(url);
  });
};

module.exports = robot =>
  robot.respond(/(lukas|lucas) ?m?e?.*/i, msg => lukas_search(msg))
;
