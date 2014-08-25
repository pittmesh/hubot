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

  robot.hear /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/, (msg) ->
    # matched a URL, see if it's http AND reddit
    scheme = msg.match[1]
    hostname = msg.match[2] + msg.match[3]
    path = msg.match[4]

    if scheme == "http://" && hostname.indexOf "reddit.com"
      msg.send "Secure link: https://pay.reddit.com" + path

  robot.hear /\ \/r\/([A-Za-z0-9\_]*)[\ $]/i, (msg) ->
    msg.send "https://pay.reddit.com/r/#{msg.match[1]}" if msg.match[1].length > 0
