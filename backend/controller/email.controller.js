const express = require("express");
const nodeMailer = require("nodemailer");
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

router.post("/forgetPassword", async (req, res) => {
  try {
    const { email } = req.body;

    const isUser = await User.findOne({ email }).exec();
    console.log(isUser);
    const otp = Math.floor(Math.random() * 1000000);

    if (isUser) {
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
        } else {
          console.log("Email sent: " + info.response);
        }
      });

      setTimeout(async() => {
        const otpTimeout = await Otp.findOneAndDelete({ userId: isUser._id }).exec();
        console.log(otpTimeout); 
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

module.exports = router;
