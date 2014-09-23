# Description:
#   Gives randos a link to pittmesh's fork of hubot.
#
# Dependencies:
#   None
#
# Commands:
#   show me the code
#
# Configuration:
#   None
#
# Author:
#   colindean
module.exports = (robot) ->
  robot.respond /(show me the code)/i, (msg) ->
    msg.reply "Download me from https://github.com/pittmesh/hubot"
