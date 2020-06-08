require('jquery-validation');
require('jquery-validation/dist/additional-methods.js');

const CONSTANT = require('./lib/constant');

$('.edit-profile').validate({
  errorElement: 'span',
  rules: {
    'user[username]': {
      required: true,
      minlength: CONSTANT.USERNAME_MIN_LENGTH,
      pattern: CONSTANT.USERNAME_PATTERN,
    },
    'user[password]': {
      required: false,
      minlength: CONSTANT.PASSWORD_MIN_LENGTH
    },
    'user[password_confirmation]': {
      equalTo : '#user_password'
    },
  },
});
