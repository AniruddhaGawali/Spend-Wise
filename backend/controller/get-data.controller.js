const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth.middleware');
const User = require('../model/user.model');
const Account = require('../model/account.model');
const Transaction = require('../model/transaction.model');

// For Decryption of Data
const DecryptData = require('./../Encryption').decrypt;

// GET all user data, including accounts and transactions

  /*
    * GET: api/all-data
  */
router.get('/', auth, async (req, res) => {
  try {
    // Get user data
    const user = await User.findById(req.userId).select('-password');
    let accountPromises = [];

    // Get user's accounts
    user.accounts.forEach((accId) => {
      accountPromises.push(Account.findById(accId));
    });

    const accounts = await Promise.all(accountPromises);

    // Decrypt account names
    accounts.forEach((acc) => {
      acc.name = DecryptData(acc.name) === "" ? acc.name : DecryptData(acc.name) ;
    });

    // Get user's transactions
    const transactions = await Transaction.find({ userId: user.id });

    // Decrypt transaction names
    transactions.forEach((t) => {
      t.title = DecryptData(t.title) === "" ? t.title : DecryptData(t.title);
    });

    // Return all data
    res.status(200).json({ user, accounts, transactions });
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
});

module.exports = router;
