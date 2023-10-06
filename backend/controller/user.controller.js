const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const User = require('../model/user.model');
const Account = require('../model/account.model');
const auth = require('../middleware/auth.middleware');

const router = express.Router();

// POST /api/register
router.post('/register', async (req, res) => {
  try {
    const { username, password } = req.body;

    // Check if user already exists
    const existingUser = await User.findOne({ username });
    if (existingUser) {
      return res.status(400).json({ message: 'User already exists' });
    }

    // Create new user
    const newUser = new User({
      username,
      password: await bcrypt.hash(password, 10),
      account: [],
    });

    // Save user to database
    await newUser.save();

    res.status(201).json({ message: 'User created successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// POST /api/login
router.post('/login', async (req, res) => {
  try {
    const { username, password } = req.body;

    // Check if user exists
    const user = await User.findOne({ username });
    if (!user) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    // Check if password is correct
    const isPasswordCorrect = await bcrypt.compare(password, user.password);
    if (!isPasswordCorrect) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    // Create and sign JWT token
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET);

    res.status(200).json({ token });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// PUT /api/user/add-account
router.put('/add-account', auth, async (req, res) => {
  try {
    const { name, balance, type } = req.body;

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

    res
      .status(201)
      .json({ message: 'Account created and added to user successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
