set :output, File.join(Whenever.path, 'log', 'cron.log')
job_type :runner,  "cd :path && bundle exec bin/rails runner -e :environment ':task' :output"

# Fetch clubs and enrolled clubs every day
every 1.day, at: '4:30 am' do
  runner 'User.daily_update'
end
