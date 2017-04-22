Airbrake.configure do |config|
    config.api_key = '86e6c7d805891ff1e25b555e3d27e15d'
    config.host    = 'errbit.awesomepeople.tv'
    config.port    = 80
    config.secure  = config.port == 443
end
