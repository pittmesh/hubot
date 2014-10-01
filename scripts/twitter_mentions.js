// Description:
//  Shows recent mentions for a twitter account. 
//
// Commands:
//   hubot show twitter mentions
//
// Dependencies:
//   twit
//
// Configuration:
//   TWITTER_CONSUMER_KEY
//   TWITTER_CONSUMER_SECRET
//   TWITTER_ACCESS_TOKEN
//   TWITTER_ACCESS_TOKEN_SECRET
//
// Author:
//   Jon Daniel
//
module.exports = function(robot) {
  var check_configuration_sanity = function(logger) {
    var ok = true;
    var log_message = function(key) {
      return "Twitter Mentions : Must set " + key + " environment variable"
    };

    if(!process.env.TWITTER_CONSUMER_KEY) {
      logger.warning(log_message("TWITTER_CONSUMER_KEY")); 
      ok = false; 
    }
    if(!process.env.TWITTER_CONSUMER_SECRET) {
      logger.warning(log_message("TWITTER_CONSUMER_SECRET")); 
      ok = false; 
    }
    if(!process.env.TWITTER_ACCESS_TOKEN) {
      logger.warning(log_message("TWITTER_ACCESS_TOKEN")); 
      ok = false; 
    }
    if(!process.env.TWITTER_ACCESS_TOKEN_SECRET) {
      logger.warning(log_message("TWITTER_ACCESS_TOKEN_SECRET")); 
      ok = false; 
    }

    return ok; 
  };

  if(!check_configuration_sanity(robot.logger)) {
    return
  }

  var Twit = require('twit');
  var T = new Twit({
    consumer_key: process.env.TWITTER_CONSUMER_KEY, 
    consumer_secret: process.env.TWITTER_CONSUMER_SECRET,
    access_token: process.env.TWITTER_ACCESS_TOKEN,
    access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET
  });
  var format_tweet = function(tweet) {
    return '@' + tweet.user.screen_name + 
      ' says ' + tweet.text + 
      ' - ' + link_to_tweet(tweet)
  };
  var link_to_tweet = function(tweet) {
    return "http://twitter.com/" + tweet.user.id_str + 
      "/status/" + tweet.id_str
  };

  robot.respond(/(show twitter mentions)/i, function(msg) {
    var params = {count: 3}

    T.get('statuses/mentions_timeline', params, function(err, data, response) {
      data = typeof data !== 'undefined' ? data : [];
      data.forEach(function(tweet) { 
        msg.send(format_tweet(tweet));
      });
    }); 
  });
}
