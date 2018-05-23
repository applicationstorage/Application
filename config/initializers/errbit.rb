Airbrake.configure do |config|
  config.api_key = '4b88e0f09b67929c0a4b268fd9064a95'
  config.host    = 'errbit.hut.shefcompsci.org.uk'
  config.port    = 443
  config.secure  = config.port == 443
end
