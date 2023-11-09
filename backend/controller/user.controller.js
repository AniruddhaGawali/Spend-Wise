const express = require("express");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

const User = require("../model/user.model");
const Account = require("../model/account.model");
const Transaction = require("../model/transaction.model");
const auth = require("../middleware/auth.middleware");

const router = express.Router();

/*
 * POST /api/user/register
 */

router.post("/register", async (req, res) => {
  try {
    const { username, password, email } = req.body;

    // Check if user already exists
    const existingUser = await User.findOne({ username });
    if (existingUser) {
      return res.status(409).json({ message: "User already exists" });
    }

    // Create new user
    const newUser = new User({
      username,
      password: await bcrypt.hash(password, 10),
      email,
      account: [],
    });

    // Save user to database
    await newUser.save();

    const token = jwt.sign({ id: newUser._id }, process.env.JWT_SECRET);

    res.status(201).json({ message: "User created successfully", token });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
});

/*
 * POST /api/user/login
 */

router.post("/login", async (req, res) => {
  try {
    const { username, password } = req.body;

    // Check if user exists
    const user = await User.findOne({ username });
    if (!user) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // Check if password is correct
    const isPasswordCorrect = await bcrypt.compare(password, user.password);
    if (!isPasswordCorrect) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // Create and sign JWT token
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET);

    res.status(200).json({ token });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
});

/*
 * DELETE /api/user/delete
 */

router.delete("/delete", auth, async (req, res) => {
  try {
    // Delete user
    const user = await User.findById(req.userId);
    const transactions = await Transaction.find({ userId: req.userId });
    transactions?.forEach(async (t) => {
      await Transaction.findByIdAndDelete(t._id);
    });

    user?.accounts.forEach(async (acc) => {
      await Account.findByIdAndDelete(acc);
    });

    await User.findByIdAndDelete(req.userId);

    res.status(200).json({ message: "User deleted successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
});

/*
 * GET /api/user/image (get user image bits)
 */
router.post("/image/:id", auth, async (req, res) => {
  try {
    const { image } = req.params.id;
    const user = await User.findById(req.userId);
    user.image = image;
    await user.save();
    res.status(200).json({ message: "Image updated successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
});

module.exports = router;
