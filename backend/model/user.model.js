const mongoose = require('mongoose');
const client = require('../config/connect');
const Schema = mongoose.Schema;

const userSchema = new Schema({
  username: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
  email : {
    type: String,
    required: true,
    unique: true,
  },
  accounts: [
    {
      type: Schema.Types.ObjectId,
      ref: 'Account',
    },
  ],
  image: {
    type: String,
    required: false,
  },
});

const User = client.model('User', userSchema);

module.exports = User;
