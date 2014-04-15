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

  robot.hear /\/r\/([A-Za-z0-9\_]*)/i, (msg) ->
    msg.send "https://pay.reddit.com/r/#{msg.match[1]}" if !msg.match[1].length > 0
