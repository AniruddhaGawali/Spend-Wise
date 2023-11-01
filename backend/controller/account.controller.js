const express = require("express");
const router = express.Router();
const auth = require("../middleware/auth.middleware");
const Account = require("../model/account.model");
const Transaction = require("../model/transaction.model");
const User = require("../model/user.model");

// For updating the balance and name of an account

  /*
    * PUT: api/account/update/:id
  */

router.put("/update/:id", auth, async (req, res) => {
  try {
    // get the balance and name from the request body
    const { balance, name, type } = req.body;
    const id = req.params.id;

    // find the account by id
    const accounts = await Account.findById(id);

    let flag = false;

    // if account exists, update the balance and name
    if (accounts) {
      accounts.balance = balance;
      accounts.name = name;
      accounts.type = type;
      flag = true;
      await accounts.save();
    }

    //   return the message
    if (flag) {
      res.status(201).json({ account: accounts });
    } else {
      res.status(500).send("Server Error");
    }
  } catch (error) {
    console.error(error);
    res.status(500).send("Server Error");
  }
});

  /*
    *DELETE:  api/account/delete/:id
  */
 
router.delete("/delete/:id", auth, async (req, res) => {
  try {
    const id = req.params.id;

    // find the account by id
    const account = await Account.findByIdAndDelete(id);
    const transactions = await Transaction.find({ accountId: id });
    const user = await User.findById(req.userId);
    user.set({ accounts: user.accounts.filter((acc) => acc != id) });
    await user.save();

    let flag = false;

    // if account exists, update the balance and name
    if (transactions && account) {
      transactions.forEach(async (transaction) => {
        await Transaction.deleteOne({ _id: transaction._id });
      });
      flag = true;
    }

    //   return the message
    if (flag) {
      res.status(201).json({ message: "Account Deleted" });
    } else {
      res.status(500).send("Server Error");
    }
  } catch (error) {
    console.error(error);
    res.status(500).send("Server Error");
  }
});

module.exports = router;
