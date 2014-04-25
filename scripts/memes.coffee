# Description:
#   PittMesh and Meta Mesh memes
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# Author:
#   colindean

module.exports = (robot) ->

  robot.hear /prawns/i, (msg) ->
    msg.send "fookin' prawns!"

  robot.hear /intens/i, (msg) ->
    msg.emote "intensifies"
