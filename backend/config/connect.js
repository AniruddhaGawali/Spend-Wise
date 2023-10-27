const dotenv = require('dotenv');
const mongoose = require('mongoose');
dotenv.config();

const connectUrl = process.env.DEVELOPMENT ? process.env.MONGO_URI_DEV : process.env.MONGO_URI;
const client = mongoose.createConnection(connectUrl, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

module.exports = client;
