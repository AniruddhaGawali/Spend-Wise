const express = require("express");
const nodeMailer = require("nodemailer");
const bcrypt = require("bcrypt");
const router = express.Router();
const User = require("../model/user.model");
const Otp = require("../model/otp.model");

const transporter = nodeMailer.createTransport({
  service: "gmail",
  auth: {
    user: "mindstack.offical@gmail.com",
    pass: "zotdbszrkknkfuhe",
  },
});

  /*
    * POST /api/email/forgetPassword/:id
  */

router.post("/forgetPassword/:id", async (req, res) => {
  try {
    const email = req.params.id;
    const isUser = await User.findOne({ email }).exec();
    const otp = Math.floor(Math.random() * 1000000);

    if (isUser) {
      const otpExists = await Otp.findOne({ userId: isUser._id }).exec();
      if (otpExists) {
        return res.status(409).json({ message: "Otp already exists" });
      }

      const newOtp = new Otp({
        userId: isUser._id,
        otp: otp,
      });

      await newOtp.save();

      const mailOptions = {
        from: "aniruddhagawali05@gmail.com",
        to: email,
        subject: "Password Reset",
        html: ` <h1>Password Reset OTP</h1>
                <p>Hello,</p>
                <p>You have requested to reset your password. Please use the following OTP to complete the process:</p>
                <div style="background-color: #f0f0f0; padding: 10px; border-radius: 5px; display: inline-block;">
                    <span style="font-size: 18px; font-weight: bold; color: #4285f4;">${otp}</span>
                </div>
                <p>If you did not request a password reset, please ignore this email.</p>
                <p>Thank you!</p>`,
      };

      transporter.sendMail(mailOptions, function (error, info) {
        if (error) {
          console.log(error);
          res.status(500).json({ message: "Server error" });
        } else {
          res.status(200).json({ message: "Email sent successfully" });
        }
      });

      setTimeout(async () => {
        try {
          await Otp.findByIdAndDelete(newOtp._id).exec();
        } catch (err) {
          res.status(500).json({ message: "Server error" });
        }
      }, 1000 * 60 * 5);

      res.status(200).json({ message: "OTP sent successfully" });
    } else {
      res.status(400).json({ message: "User does not exist" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
});

  /*
    * POST /api/email/verify
  */

router.post("/verify", async (req, res) => {
  const { otp, email } = req.body;
  try {
    const getGmail = await User.findOne({ email }).exec();
    if (getGmail) {
      const otpVerify = await Otp.findOne({ userId: getGmail._id }).exec();
      if (otpVerify && otpVerify.otp === otp) {
        
        res.status(202).json({ message: "Otp verified" });
      } else {
        res.status(400).json({ message: "Otp not verified" });
      }
    } else {
      res.status(400).json({ message: "User does not exist" });
    }
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: "Server error" });
  }
});

  /*
    * POST /api/email/resetPassword
  */

  router.post('/resetPassword', async (req, res) => {
    try {
      const { password,email } = req.body;
  
      // Check if user already exists
      const existingUser = await User.findOne({ email });
      if (!existingUser) {
        return res.status(409).json({ message: 'User doesnt exists' });
      }
      
      // update password
      const newPassword = await bcrypt.hash(password, 10);

      existingUser.password = newPassword;
      await existingUser.save();
      
      res.status(201).json({ message: 'Reset password successfully' });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Server error' });
    }
  });



module.exports = router;