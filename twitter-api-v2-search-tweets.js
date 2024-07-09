// twiiter-api-v2-search-tweets
require('dotenv').config();
const { TwitterApi } = require('twitter-api-v2');

// Load Twitter API keys and tokens from .env file
// const client = new TwitterApi(process.env.BEARER_TOKEN);

// Function to search and read tweets
const searchTweetsFromUser = async (query, username) => {
    try {
        const client = await new TwitterApi({
            appKey: process.env.CONSUMER_KEY,
            appSecret: process.env.CONSUMER_SECRET,
            accessToken: process.env.ACCESS_TOKEN,
            accessSecret: process.env.ACCESS_TOKEN_SECRET,
        });

        const tweets = await client.v2.search(`from:${username} "${query}"`, {
            max_results: 100,
        });
        // Consume every possible tweet of jsTweets (until rate limit is hit)
        for await (const tweet of tweets) {
            // console.log(tweet);
            console.log('tweet:', tweet);
        }
    } catch (error) {
        console.log('tweets catch:', error);
    }
};

// Example query
console.log('start --');
const query = 'Solidity Challenge #';
const username = 'CalyptusCareers';
searchTweetsFromUser(query, username);
console.log('end --');
// process.exit();
