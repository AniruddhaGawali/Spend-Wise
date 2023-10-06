const mongoose = require('mongoose');
const client = require('../config/connect');

const transactionSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true,
    },
    amount: {
      type: Number,
      required: true,
    },
    accountId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Account',
      required: true,
    },
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    type: {
      type: String,
      enum: ['income', 'expense'],
      required: true,
    },
    catergory: {
      type: String,
      enum: [
        'food',
        'transport',
        'entertainment',
        'education',
        'gifts',
        'medical',
        'subscriptions',
        'clothing',
        'investments',
        'travel',
        'investments',
      ],
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

const Transaction = client.model('Transaction', transactionSchema);

module.exports = Transaction;
