const CONSTANT = require('./constant');

const passwordValidationRule = {
  'user[password]': {
    required: true,
    minlength: CONSTANT.PASSWORD_MIN_LENGTH
  },
  'user[password_confirmation]': {
    equalTo : '#user_password'
  },
}

module.exports = passwordValidationRule;
