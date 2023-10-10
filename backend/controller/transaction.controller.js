const express = require('express');

const Transaction = require('../model/transaction.model');
const Account = require('../model/account.model');
const auth = require('../middleware/auth.middleware');

const router = express.Router();

router.get('/', auth, async (req, res) => {
  try {
    const transactions = await Transaction.find({ user: req.userId });
    res.status(200).json(transactions);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server Error' });
  }
});

router.post('/add', auth, async (req, res) => {
  try {
    const { title, accountId, type, amount, category, date } = req.body;
    const userId = req.userId;

    let tDate = new Date(date);

    // Create new account
    const newTransaction = new Transaction({
      title,
      accountId,
      type,
      amount,
      category,
      userId,
      date: tDate,
    });

    // Save account to database
    await newTransaction.save();

    await Account.updateOne(
      { _id: accountId },
      {
        $inc: {
          balance: type === 'income' ? +amount : -amount,
        },
      }
    );

    await res.status(201).json({
      message: 'New Transaction created and added to user successfully',
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
