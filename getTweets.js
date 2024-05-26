// getTweets.js
const needle = require('needle');
require('dotenv').config();

const token = process.env.TWITTER_BEARER_TOKEN;
const endpointUrl = 'https://api.twitter.com/2/tweets/search/all';

async function getTweets() {
  const params = {
    'query': 'from:CalyptusCareers "Solidity Challenge #"',
    'tweet.fields': 'created_at',
    'max_results': 10
  };

  const options = {
    headers: {
      'authorization': `Bearer ${token}`
    }
  };

  try {
    const response = await needle('get', endpointUrl, params, options);

    if (response.body) {
      const tweets = response.body.data;
      if (tweets && tweets.length > 0) {
        console.log(`Found ${tweets.length} tweets:`);
        tweets.forEach(tweet => {
          console.log(`- ${tweet.text} (created at: ${tweet.created_at})`);
        });
      } else {
        console.log('No tweets found.');
      }
    } else {
      console.error('Error fetching tweets:', response.body);
    }
  } catch (error) {
    console.error('Error fetching tweets:', error);
  }
}

getTweets();
