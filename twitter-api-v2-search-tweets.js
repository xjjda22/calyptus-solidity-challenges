// twiiter-api-v2-search-tweets
require('dotenv').config();
const { TwitterApi } = require('twitter-api-v2');

// Load Twitter API keys and tokens from .env file
// const client = new TwitterApi(process.env.BEARER_TOKEN);
const client = new TwitterApi({
  appKey: process.env.CONSUMER_KEY,
  appSecret: process.env.CONSUMER_SECRET,
  accessToken: process.env.ACCESS_TOKEN,
  accessSecret: process.env.ACCESS_TOKEN_SECRET,
});

// Function to search and read tweets
const searchTweetsFromUser = async (query, username) => {
    try {
        const tweets = await client.v2.search(query, {
            'tweet.fields': 'author_id,created_at',
            expansions: 'author_id',
            max_results: 100,
            query: `from:${username} "${query}"`,
        });
        console.log('tweets:', tweets.data);
    } catch (error) {
        console.log('tweets catch:', error);
    }
}

// Example query
console.log('start --');
const query = 'Solidity Challenge #';
const username = 'CalyptusCareers';
searchTweetsFromUser(query, username);
console.log('end --');
process.exit();
