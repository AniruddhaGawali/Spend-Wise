const express = require("express");
const router = express.Router();
const auth = require("../middleware/auth.middleware");
const Account = require("../model/account.model");

// For updating the balance and name of an account

// api/account/update
router.put("/update/:id", auth, async (req, res) => {
  try {
    // get the balance and name from the request body
    const { balance, name } = req.body;
    const id = req.params.id;

    // find the account by id
    const accounts = await Account.findById(id);

    let flag = false;

    // if account exists, update the balance and name
    if (accounts) {
      accounts.balance = balance;
      accounts.name = name;
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

module.exports = router;
