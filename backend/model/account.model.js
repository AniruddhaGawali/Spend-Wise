const mongoose = require('mongoose');
const client = require('../config/connect');

const accountSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  type: {
    type: String,
    enum: ['cash', 'bank'],
    required: true,
  },
  balance: {
    type: Number,
    required: true,
  },
});

const Account = client.model('Account', accountSchema);

module.exports = Account;
