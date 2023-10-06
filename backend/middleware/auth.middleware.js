const jwt = require('jsonwebtoken');

const authMiddleware = (req, res, next) => {
  // Get the token from the request header

  try {
    const authHeader = req.header('authorization');
    const token = authHeader && authHeader.split(' ')[1];

    // Check if token exists
    if (!token) {
      return res.status(401).json({ msg: 'No token, authorization denied' });
    }

    try {
      // Verify the token
      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      // Add the user id to the request object
      req.userId = decoded.id;

      // Call the next middleware
      next();
    } catch (err) {
      res.status(401).json({ msg: 'Token is not valid' });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: 'Server Error' });
  }
};

module.exports = authMiddleware;
