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
    'Ping': base_selector + " div.share-info share-ping p",
    'Rating': base_selector + " div.share-info share-rating p",
    'Device': base_selector + " div.share-info share-device p",
    'ISP': base_selector + " div.share-info share-isp p",
    'Server': base_selector + " div.share-info share-server p",
    'Timestamp': base_selector + " div.share-meta share-meta-date"
  }


  robot.hear /http\:\/\/www\.speedtest\.net\/my-result\/\d*/, (msg) ->
    console.log("getting " + msg.match)
    robot.http(msg.match)
    #robot.http("http://cad.cx")
       .header('User-Agent', 'Mozilla/5.0')
       .get() (err, res, body) ->
         console.log(err) if err
         handler = new HTMLParser.DefaultHandler((() ->),
            ignoreWhitespace: true
         )
         parser = new HTMLParser.Parser handler
         parser.parseComplete body

         for thing, selector of selectors
           msg.send Select handler.dom, selector
