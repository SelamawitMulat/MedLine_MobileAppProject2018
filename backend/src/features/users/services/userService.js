const userRepository = require('../repositories/userRepository');

exports.getAllUsers = async () => {
  return userRepository.findAllUsers();
};
