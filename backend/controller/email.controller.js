/*
    ! Coming soon
*/

const express = require("express");
const nodeMailer = require("nodemailer");
const router = express.Router();
const User = require("../model/user.model");
const Otp = require("../model/otp.model");

const transporter = nodeMailer.createTransport({
    service: 'gmail',
    auth: {
        user: "mindstack.offical@gmail.com",
        pass: "zotdbszrkknkfuhe",
    }
});


router.post("/forgetPassword", async (req, res) => {
    try {

        const { email } = req.body;

        const isUser = User.findOne({ email });
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
                html: `Your OTP is ${otp}`
            };

            transporter.sendMail(mailOptions, function (error, info) {
                if (error) {
                    console.log(error);
                } else {
                    console.log('Email sent: ' + info.response);
                }
            });
            res.status(200).json({ message: "OTP sent successfully" });
        }else{
            res.status(400).json({ message: "User does not exist" });
        }

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server error" });
    }

});

module.exports = router;