const express = require("express");
const router = express.Router();
const auth = require("../middleware/auth.middleware");
const Account = require("../model/account.model");
const Transaction = require("../model/transaction.model");
const User = require("../model/user.model");

// For Encrypted Data
const EncryptData = require("./../Encryption").encrypt;
// For Decryption of Data
const DecryptData = require('./../Encryption').decrypt;

/*
 * POST /api/account/add-account
 */

router.post("/add-account", auth, async (req, res) => {
  try {
    // const to let
    let { name, balance, type } = req.body;
    name = EncryptData(name);

    // Create new account
    const newAccount = new Account({
      name,
      balance,
      type,
    });

    // Save account to database
    await newAccount.save();

    // Add account ID to user's account array
    const user = await User.findById(req.userId);
    user.set({ accounts: [...user.accounts, newAccount._id] });
    await user.save();

    newAccount.name = DecryptData(newAccount.name);

    res
      .status(201)
      .json({ account: newAccount });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
});

// For updating the balance and name of an account

/*
 * PUT: api/account/update/:id
 */

router.put("/update/:id", auth, async (req, res) => {
  try {
    // get the balance and name from the request body
    let { balance, name, type } = req.body;

    name = EncryptData(name);

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

    accounts.name = DecryptData(accounts.name);

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
    const account = await Account.findById(id).exec();
    let flag = false;
    if (account) {
      const user = await User.findById(req.userId);
      const transactions = await Transaction.find({ accountId: account._id });
      transactions?.forEach(async (t) => {
        await Transaction.findByIdAndDelete(t._id);
      });
      user.set({
        accounts: user.accounts.filter(
          (acc) => acc.toString() !== id.toString()
        ),
      });
      await user.save();
      await account.deleteOne();

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
