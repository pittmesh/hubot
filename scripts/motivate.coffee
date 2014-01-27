# Description:
#   Motivates users
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   !m <user> - Motivates <user>
#   !m * - Motivates channel
#
# Author:
#   colindean

module.exports = (robot) ->

  robot.hear /\!m (\w+)/i, (msg) ->
    user = msg.match[1]

    msg.send "You're doing good work, " + user + "!"

  robot.hear /\!m \*/i, (msg) ->
    msg.send "You're doing good work, " + msg.room + "!"
