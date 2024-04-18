// src/services/userService.js
const userModel = require('../models/userModel');

exports.getUserDetails = (userId, callback) => {
  userModel.getUserDetails(userId, callback);
};
