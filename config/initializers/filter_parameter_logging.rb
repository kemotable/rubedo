# frozen_string_literal: true

# Configure parameters to be filtered from the log file.
# This prevents sensitive information from being written to logs.
Rails.application.config.filter_parameters += %i[
  passw email secret token _key crypt salt certificate otp ssn cvv cvc
  authorization jwt access_token refresh_token client_secret
]
