const CryptoJS = require("crypto-js");

const secretKey =  process.env.JWT_SECRET;

// Function to encrypt a string
function encrypt(inputString) {
  const encrypted = CryptoJS.AES.encrypt(inputString, secretKey).toString();
  return encrypted;
}

// Function to decrypt a string
function decrypt(encryptedString) {
  const decrypted = CryptoJS.AES.decrypt(encryptedString, secretKey).toString(CryptoJS.enc.Utf8);
  return decrypted;
}

module.exports = { encrypt, decrypt };