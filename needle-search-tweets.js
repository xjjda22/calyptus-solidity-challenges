// needle-search-tweets
require('dotenv').config();
const needle = require('needle');

// The code below sets the bearer token from your environment variables
// To set environment variables on macOS or Linux, run the export command below from the terminal:
// export BEARER_TOKEN='YOUR-TOKEN'
const token = process.env.BEARER_TOKEN;

// Function to search and read tweets
const searchTweetsFromUser = async (query, username) => {
    try {
        // Edit query parameters below
        // specify a search query, and any additional fields that are required
        // by default, only the Tweet ID and text fields are returned
        const params = {
            query: `from:${username} "${query}"`,
            'tweet.fields': 'author_id',
        };

        const endpointUrl = 'https://api.twitter.com/2/tweets/search/recent';
        const res = await needle('get', endpointUrl, params, {
            headers: {
                'User-Agent': 'v2RecentSearchJS',
                authorization: `Bearer ${token}`,
            },
        });

        if (res.body) {
            console.log('tweets:', res.body);
        }
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
