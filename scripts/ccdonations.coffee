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
        total = address.total_received
        balance = address.final_balance

        msg.send "The address #{address.address} has received " +
          "#{total/100000000} BTC total and currently has" +
          " #{balance/100000000} BTC."
  robot.respond /dogecoin balance/i, (msg) ->
    default_address = 'DMMx3mSt5swBqQZEwtw3haYmMoLwmSP3zj'
    robot.http('http://dogechain.info/chain/Dogecoin/q/addressbalance/'+default_address)
      .get() (err, res, body) ->
        balance = body
        msg.send "#{default_address} has #{balance} DOGE. Such balance. "+
          "Very generosity. So wow."

  robot.respond /litecoin balance/i, (msg) ->
    default_address = 'LMMQQNHT172pK6Ys9u64fFbodHtHGWJHBX'
    robot.http('https://ltc.blockr.io/api/v1/address/info/'+default_address)
      .get() (err, res, body) ->
        address = JSON.parse(body).data
        total = address.totalreceived
        balance = addressbalance

        msg.send "The address #{address.address} has received #{total} LTC total"+
          "and currently has #{balance} LTC."
        
