Airbrake.configure do |config|
  config.api_key = '47ef697722f25e7952911b731b975eda'
  config.host    = 'errbit.awesomepeople.tv'
  config.port    = 80
  config.secure  = config.port == 443
end
