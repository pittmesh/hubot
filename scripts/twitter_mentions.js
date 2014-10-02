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
  var store_since_id = function(tweets) {
    if(tweets[0]) {
      robot.brain.data.twitter_since_id = tweets[0].id_str;
    }
  };
  var interval_callback = function() {
    var params = {count: 3};
    var msg = new robot.Response(robot, '');

    if(robot.brain.data.twitter_since_id) {
      params.since_id = robot.brain.data.twitter_since_id; 
    }

    TwitterMentions.recent_mentions(params, function(tweets) {
      store_since_id(tweets);
      TwitterMentions.display_tweets(msg, tweets);
    });    
  };

  if(!TwitterMentions.check_configuration_sanity(robot.logger)) {
    return
  }
  
  TwitterMentions.setup({
    consumer_key: process.env.TWITTER_CONSUMER_KEY, 
    consumer_secret: process.env.TWITTER_CONSUMER_SECRET,
    access_token: process.env.TWITTER_ACCESS_TOKEN,
    access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET
  });

  setInterval(interval_callback, 1000 * 60);

  robot.respond(/(show twitter mentions)/i, function(msg) {
    var params = {count: 3};
    TwitterMentions.recent_mentions(params, function(tweets) {
      TwitterMentions.display_tweets(msg, tweets);
    });
  });
}

var Twit = require('twit');
var TwitterMentions = {
  twit : null,

  setup : function(config) {
    this.twit = new Twit(config);
  },

  display_tweets : function(msg, tweets) {
    tweets = typeof tweets !== 'undefined' ? tweets : [];
    tweets.forEach(function(tweet) {
      msg.send(TwitterMentions.format_tweet(tweet));
    });
  },

  recent_mentions : function(params, callback) {
    this.twit.get('statuses/mentions_timeline', params, function(err, data, response) {
      data = typeof data !== 'undefined' ? data : [];
      callback(data);
    });
  },

  format_tweet : function(tweet) {
    return '@' + tweet.user.screen_name + 
      ' says ' + tweet.text + 
      ' - ' + this.link_to_tweet(tweet)
  },

  link_to_tweet : function(tweet) {
    return "http://twitter.com/" + tweet.user.id_str + 
      "/status/" + tweet.id_str
  },

  check_configuration_sanity : function(logger) {
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
  }
};
