raise 'RCC_PRIV not set' unless ENV['RCC_PRIV']
raise 'RCC_PUB not set' unless ENV['RCC_PUB']
Recaptcha.configure do |config|
  config.public_key = ENV['RCC_PRIV']
  config.private_key = ENV['RCC_PUB']
end

