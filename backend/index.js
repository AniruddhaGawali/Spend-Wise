const express = require('express');
var cors = require('cors');
var bodyParser = require('body-parser');

const PORT = process.env.PORT || 5500;
const app = express();

app.use(bodyParser.json());

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.use('/api/account', require('./controller/account.controller'));
app.use('/api/email', require('./controller/email.controller'));
app.use('/api/all-data', require('./controller/get-data.controller'));
app.use('/api/transaction', require('./controller/transaction.controller'));
app.use('/api/user', require('./controller/user.controller'));
app.use('/api/version', require('./controller/version.controller'));

app.listen(PORT, async () => {
  console.log(`Listening on the port ${PORT}`);
});

