const mongoose = require('mongoose');
const client = require('../config/connect');
const Schema = mongoose.Schema;

const otpSchema = new Schema({
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