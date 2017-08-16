# Description:
#   Provide Introduction
#
introduction = [
  "https://photos.app.goo.gl/n8YOhdNAeuZZ22pz1",
  "okay, you're rex roof",
  "you were raised on a farm in Maybee, Michigan (real place)",
  "you learned unix in the early 90s from M-Net, a public access unix machine in Ann Arbor.",
  "later you worked at Washtenaw Community College as a lead systems engineer",
  "You joined Blue Newt Software in 2015, have been helping them design infrastructure and deploy software"
]

module.exports = (robot) ->
  robot.respond /(who am i\?|introduce me)/i, (msg) ->
    for x of introduction
      setTimeout ((y) ->
        msg.send "#{introduction[y]}"
      ), (1500 * x), x
    msg.finish()
