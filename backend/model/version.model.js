const mongoose = require('mongoose');
const client = require('../config/connect');

const versionSchema = new mongoose.Schema(
  {
    version: {
      type: mongoose.Schema.Types.String,
      required: true,
      unique: true,
    },
    update_link: {
      type: mongoose.Schema.Types.String,
      required: true,
    },
    description: {
      type: mongoose.Schema.Types.Array,
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

const Update = client.model('Version', versionSchema);
module.exports = Update;
