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

  log_message = (key) ->
    return "CCDonations: Set " + key + " environment variable!"

  if !process.env.CC_ADDRESS_BITCOIN
    robot.logger.warning log_message("CC_ADDRESS_BITCOIN")


  if !process.env.CC_ADDRESS_LITECOIN
    robot.logger.warning log_message("CC_ADDRESS_LITECOIN")


  if !process.env.CC_ADDRESS_DOGECOIN
    robot.logger.warning log_message("CC_ADDRESS_DOGECOIN")


  bitcoin_balance = (msg) ->
    default_address = process.env.CC_ADDRESS_BITCOIN
    robot.http("http://blockchain.info/address/" + default_address)
      .query({
        format: 'json'
      })
      .get() (err, res, body) ->
        address = JSON.parse(body)
        total = address.total_received
        balance = address.final_balance

        msg.send "The address #{address.address} has received " +
          "#{total/100000000} BTC total and currently has" +
          " #{balance/100000000} BTC."

  dogecoin_balance = (msg) ->
    default_address = process.env.CC_ADDRESS_DOGECOIN
    robot.http('http://dogechain.info/chain/Dogecoin/q/addressbalance/'+default_address)
      .get() (err, res, body) ->
        # at some point, they added this stupid random html comment
        balance = body.substring(0,body.indexOf('<!--'))
        msg.send "#{default_address} has #{balance} DOGE. Such balance. "+
          "Very generosity. So wow."

  litecoin_balance = (msg) ->
    default_address = process.env.CC_ADDRESS_LITECOIN
    robot.http('https://ltc.blockr.io/api/v1/address/info/'+default_address)
      .get() (err, res, body) ->
        address = JSON.parse(body).data
        total = address.totalreceived
        balance = address.balance

        msg.send "The address #{address.address} has received #{total} LTC total"+
          " and currently has #{balance} LTC."

  robot.respond /bitcoin balance/i, (msg) ->
    bitcoin_balance(msg)
  robot.respond /dogecoin balance/i, (msg) ->
    dogecoin_balance(msg)
  robot.respond /litecoin balance/i, (msg) ->
    litecoin_balance(msg)
  robot.respond /crypto balances/i, (msg) ->
    for f in [bitcoin_balance, dogecoin_balance, litecoin_balance]
      f(msg)
