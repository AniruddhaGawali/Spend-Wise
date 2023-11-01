const dotenv = require("dotenv");
const mongoose = require("mongoose");
dotenv.config();

const connectUrl =
  process.env.DEVELOPMENT == "true" ||
  process.env.DEVELOPMENT == "TRUE" ||
  process.env.DEVELOPMENT == "True"
    ? process.env.MONGO_URI_DEV
    : process.env.MONGO_URI;
const client = mongoose.createConnection(connectUrl, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

module.exports = client;
