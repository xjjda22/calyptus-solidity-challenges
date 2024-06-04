// twiiter-search-tweets
require('dotenv').config();
const Twitter = require('twitter');

const client = new Twitter({
    consumer_key: process.env.CONSUMER_KEY,
    consumer_secret: process.env.CONSUMER_SECRET,
    access_token: process.env.ACCESS_TOKEN,
    access_token_secret: process.env.ACCESS_TOKEN_SECRET,
});

// Function to search and read tweets
const searchTweetsFromUser = async (query, username) => {
    const params = {
        screen_name: username,
        q: query,
        count: 20, // Adjust this to get more or less tweets
    };

    client
        .get('statuses/user_timeline', params)
        .then((tweets) => {
            console.log('tweets:', tweets);
        })
        .catch((error) => {
            console.log('tweets catch:', error);
        });
}

// Example query
console.log('start --');
const query = 'Solidity Challenge #';
const username = 'CalyptusCareers';
searchTweetsFromUser(query, username);
console.log('end --');
process.exit();
