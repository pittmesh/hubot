# Description:
#   Messages with Speedtest.test results when a my-result link is heard
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect": "0.2.0"
#
# Configuration:
#   None
#
# Commands:
#   None
#
# Author:
#   colindean

Select     = require("soupselect").select
HTMLParser = require "htmlparser"

module.exports = (robot) ->

  base_selector = "#content div.share-body div.share-main div.share-metrics"
  major_selector = base_selector + " div.share-major"
  info_selector = base_selector + " div.share-info"
  selectors = {
    'Download': major_selector + " div.share-download p",
    'Upload': major_selector + " div.share-upload p",
    'Ping': info_selector + " div.share-ping p",
    'Rating': info_selector + " div.share-rating p",
    'Device': info_selector + " div.share-device p",
    'ISP': info_selector + " div.share-isp p",
    'Server': info_selector + " div.share-server p",
    'Timestamp': base_selector + " div.share-meta div.share-meta-date"
  }

  flatten = (item) ->
    if item.children?
      item.children.map(flatten).join(" ")
    else
      item.raw.trim()

  # use this for testing:
  #    http://www.speedtest.net/my-result/3760429995
  # should output:
  #    ⬇︎ 150.44 Mb/s ⬆︎ 73.16 Mb/s ↻ 19 ms ⬈ VERIZON FIOS on 9/15/2014 at 12:50 AM GMT

  robot.hear /http\:\/\/www\.speedtest\.net\/my-result\/(\S*)/, (msg) ->
    robot.http("http://www.speedtest.net/my-result/#{msg.match[1]}")
       .header('User-Agent', 'Mozilla/5.0')
       .get() (err, res, body) ->
         handler = new HTMLParser.DefaultHandler((() ->),
            ignoreWhitespace: true
         )
         parser = new HTMLParser.Parser handler
         parser.parseComplete body

         results = {}

         for thing, selector of selectors
           data = Select handler.dom, selector
           if data[0]?
             value = flatten(data[0])
           else
             value = ''
           results[thing] = value unless value == ''

         msg.send "⬇︎ #{results['Download']} ⬆︎ #{results['Upload']} ↻ #{results['Ping']} ⬈ #{results['ISP']} on #{results['Timestamp']}"
