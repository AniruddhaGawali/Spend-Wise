const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth.middleware');
const User = require('../model/user.model');
const Account = require('../model/account.model');
const Transaction = require('../model/transaction.model');
const decrypt = require('../Encryption').decrypt;

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

    accounts.forEach((account) => {
      account.name = decrypt(account.name) === "" ? account.name : decrypt(account.name);
    });

    // Get user's transactions
    const transactions = await Transaction.find({ userId: user.id });

    transactions.forEach((transaction) => {
     transaction.title = decrypt(transaction.title) === "" ? transaction.title : decrypt(transaction.title);
    });

    // Return all data
    res.status(200).json({ user, accounts, transactions });
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
});


  /*
    * GET: api/month-transactions/
  */

module.exports = router;
