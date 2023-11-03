const mongoose = require('mongoose');
const client = require('../config/connect');

const otpSchema =  new mongoose.Schema({
    userId : {
        type: String,
        required: true,
    },
    otp : {
        type: Number,
        required: true,
    },
}, {
    timestamps: true,
});

const Otp = client.model('Otp', otpSchema);

module.exports = Otp;