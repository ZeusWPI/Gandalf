set :output, File.join(Whenever.path, "log", "cron.log")

env 'GEM_HOME', '/usr/local/bundle'

# Fetch clubs and enrolled clubs every day
every 1.day, :at => '4:30 am' do
  runner "User.daily_update"
end
