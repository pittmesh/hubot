# Description:
#   Works some magic with torrent files
#
# Dependencies:
#   parse-torrent
#
# Configuration:
#   none
#
# Commands:
#   hubot magnet link <torrent url>
#
# Author: 
#   colindean
#
parseTorrent = require('parse-torrent')
BINARY_ENCODING = 'binary'
magnetUrlForData = (data) ->
  console.log(data.info)
  trackers = []
  name = ""
  infohash = data.infoHash # this is required!
  if data.announce?
    trackers = data.announce.map((url) -> "tr=" + encodeURIComponent(url))
  if data.name?
    name = "dn="+encodeURIComponent(data.name)
  if data.info? and data.info.length?
    length = "xl=" + data.info.length
  "magnet:?xt=urn:btih:#{infohash}&#{trackers.join('&')}&#{name}&#{if length? then length}"


module.exports = (robot) ->
  robot.respond /magnet link (https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*).torrent)/i, (msg) ->
    url = msg.match[1]
    msg.http(msg.match[1]).encoding(BINARY_ENCODING).get() (err, res, body) ->
      if err
        msg.send "Sorry, I wasn't able to retrieve #{url} :-("
        return
      buf = new Buffer(body, BINARY_ENCODING)
      data = parseTorrent(buf)
      if data?
        msg.send magnetUrlForData(data)
      else
        msg.send "There was no data at #{url} :-("

