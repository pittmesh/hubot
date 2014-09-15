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
  selectors = {
    'Download': base_selector + " div.share-major div.share-download p",
    'Upload': base_selector + " div.share-major div.share-upload p",
    'Ping': base_selector + " div.share-info div.share-ping p",
    'Rating': base_selector + " div.share-info div.share-rating p",
    'Device': base_selector + " div.share-info div.share-device p",
    'ISP': base_selector + " div.share-info div.share-isp p",
    'Server': base_selector + " div.share-info div.share-server p",
    'Timestamp': base_selector + " div.share-meta div.share-meta-date"
  }

  base_url = "http://www.speedtest.net/my-result/"

  flatten = (item) ->
    if item.children?
      item.children.map(flatten).join(" ")
    else
      item.raw.trim()

#http://www.speedtest.net/my-result/3760429995

  robot.hear /http\:\/\/www\.speedtest\.net\/my-result\/(\d*)/, (msg) ->
    url = base_url + msg.match[1]
    robot.http(url)
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
           if data[0]? and data[0].children?
             value = data[0].children.map(flatten).join(" ")
           else
             value = ''
           results[thing] = value unless value == ''

         msg.send "⬇︎ #{results['Download']} ⬆︎ #{results['Upload']} ↻ #{results['Ping']} ⬈ #{results['ISP']} on #{results['Timestamp']}"
