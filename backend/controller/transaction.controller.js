const express = require("express");

const Transaction = require("../model/transaction.model");
const Account = require("../model/account.model");
const auth = require("../middleware/auth.middleware");

// For Encrypted Data
const EncryptData = require("./../Encryption").encrypt;
const DecryptData = require("./../Encryption").decrypt;

const router = express.Router();

/*
 * GET: api/transaction
 */
router.get("/", auth, async (req, res) => {
  try {
    const transactions = await Transaction.find({ userId: req.userId });
    
    transactions.forEach((t) => {
      t.title = DecryptData(t.title) === "" ? t.title : DecryptData(t.title);
    });

    res.status(200).json(transactions);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server Error" });
  }
});

/*
 * DELETE: api/transaction/delete/:id
 */

router.delete("/delete/:id", auth, async (req, res) => {
  try {
    const id = req.params.id;

    // If confirm is true, update account balance otherwise only delete transaction

    const transaction = await Transaction.findById(id);

    await Account.updateOne(
      { _id: transaction.accountId },
      {
        $inc: {
          balance:
            transaction.type === "income"
              ? -transaction.amount
              : +transaction.amount,
        },
      }
    );

    await Transaction.deleteOne({ _id: id });

    res.status(200).json({ message: "Transaction deleted successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server Error" });
  }
});

/*
 * POST: api/transaction/add
 */

router.post("/add", auth, async (req, res) => {
  try {
    let { title, accountId, type, amount, category, date } = req.body;
    const userId = req.userId;

    title = EncryptData(title);

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
          balance: type === "income" ? +amount : -amount,
        },
      }
    );
    
    newTransaction.title = DecryptData(newTransaction.title);
    
    res.status(201).json(newTransaction);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
});

/*
 * PUT: api/transaction/update/:id
 */

router.put("/update/:id", auth, async (req, res) => {
  try {
    let { title, accountId, type, amount, category, date } = req.body;

    title = EncryptData(title);

    const userId = req.userId;
    const id = req.params.id;
    let tDate = new Date(date);

    const oldTransaction = await Transaction.findById(id);

    // Create new account
    const newTransaction = new Transaction({
      id: id,
      title,
      accountId,
      type,
      amount,
      category,
      userId,
      date: tDate,
    });

    // Save account to database
    await Transaction.updateOne({ _id: id }, newTransaction);
    if (oldTransaction.accountId === accountId) {
      if (oldTransaction.amount > amount) {
        await Account.updateOne(
          { _id: accountId },
          {
            $inc: {
              balance:
                type === "income"
                  ? -(oldTransaction.amount - amount)
                  : +(oldTransaction.amount - amount),
            },
          }
        );
      } else {
        await Account.updateOne(
          { _id: accountId },
          {
            $inc: {
              balance:
                type === "income"
                  ? +(amount - oldTransaction.amount)
                  : -(amount - oldTransaction.amount),
            },
          }
        );
      }
    } else {
      await Account.updateOne(
        { _id: oldTransaction.accountId },
        {
          $inc: {
            balance:
              oldTransaction.type === "income"
                ? -oldTransaction.amount
                : +oldTransaction.amount,
          },
        }
      );

      await Account.updateOne(
        { _id: accountId },
        {
          $inc: {
            balance: type === "income" ? +amount : -amount,
          },
        }
      );
    }
    newTransaction.title = DecryptData(newTransaction.title)

    res.status(201).json(newTransaction);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
});

/*
 * POST : api/transaction/transfer
 */

router.post("/transfer", auth, async (req, res) => {
  try {
    // console.time('transferTime: ');
    let { fromAccount, toAccount, title, amount, date } = req.body;

    title = EncryptData(title);

    const userId = req.userId;
    let tDate = new Date(date);

    const from = await Account.findById(fromAccount);

    if (from.balance < amount) {
      res.status(400).json({ message: "Insufficient balance" });
    }

    await Account.updateOne(
      { _id: fromAccount },
      {
        $inc: {
          balance: -amount,
        },
      }
    );

    await Account.updateOne(
      { _id: toAccount },
      {
        $inc: {
          balance: amount,
        },
      }
    );

    const newTransaction = new Transaction({
      title: title,
      accountId: fromAccount,
      type: "transfer",
      amount: amount,
      category: "account",
      userId: userId,
      date: tDate,
    });

    await newTransaction.save();
    // console.timeEnd('transferTime: ');
    res.status(201).json({ message: "Transfer successful" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
});

/*
* PUT: api/transaction/deleteTransfer/:id
*/


module.exports = router;
