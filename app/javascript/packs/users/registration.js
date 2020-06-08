require('jquery-validation');
require('jquery-validation/dist/additional-methods.js');

const passwordValidationRule = require('../lib/password_validation_rule')

$('.new-user').validate({
  errorElement: 'span',
  rules: {
    'user[email]': {
      required: true,
      email: true,
    },
    ...passwordValidationRule
  },
});
