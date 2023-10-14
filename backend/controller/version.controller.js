const express = require('express');
const router = express.Router();

const Version = require('../model/version.model');

// it will give the update of app in the database
router.get('/', async (req, res) => {
  try {
    let latestUpdate = await Version.find({}).sort({ createdAt: -1 }).limit(1);

    res.status(200).json( {latestUpdate} );
  } catch (err) {
    console.log(err);
    res.status(400).json({
      err,
    });
  }
});

// it will add the update in the database

router.post('/new', async (req, res) => {
  let { version, update_link,description } = req.body;

  try {
    let update = new Version({
      version,
      update_link,
      description,
    });

    await update.save();

    res.status(200).json({update});
  } catch (err) {
    console.log(err);
    res.status(400).json({
      message: 'Update is not added',
      ack: false,
      err,
    });
  }
});

module.exports = router;
