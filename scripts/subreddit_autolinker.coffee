# Description:
#   subreddit autolinker
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

  robot.hear /\/r\/([A-Za-z0-9]*)/i, (msg) ->
    msg.send "https://pay.reddit.com/r/#{msg.match[1]}"
