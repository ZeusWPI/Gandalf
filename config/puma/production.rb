threads 0,8
workers 4

environment 'production'
daemonize

preload_app!

bind 'unix:///var/run/unicorn/puma.sock'

on_restart do
  ENV['BUNDLE_GEMFILE'] = File.join('..', '..', 'current', 'Gemfile')
end

on_worker_boot do
  ActiveRecord::Base.connection_pool.disconnect!

  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end


