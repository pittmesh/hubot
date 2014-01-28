# Description:
#   Retrieves a Bitcoin address's balance with some donation information.
#
# Dependencies: 
#   None
#
# Commands:
#   hubot bitcoin balance - returns the balance for a predetermined address
#
# Configuration:
#   None
#
# Author:
#   colindean
#
module.exports = (robot) ->
  robot.respond /bitcoin balance/i, (msg) ->
    default_address = '1meshQDzpXUQJSdNVH7BujkudqfatFxnq'
    robot.http("http://blockchain.info/address/" + default_address)
      .query({
        format: 'json'
      })
      .get() (err, res, body) ->
        address = JSON.parse(body)
        num_tx = address.n_tx
        total = address.total_received
        balance = address.final_balance

        msg.send "The address #{address.address} has received #{num_tx}" +
          " transactions totaling #{total/100000000} and has currently has" +
          " #{balance/100000000} BTC."
