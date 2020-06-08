require('jquery-validation');
require('jquery-validation/dist/additional-methods.js');

const passwordValidationRule = require('../lib/password_validator_rule')

$('.edit-password').validate({
  errorElement: 'span',
  rules: passwordValidationRule
});
