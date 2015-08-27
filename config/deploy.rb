# config valid only for Capistrano 3.1
# lock '3.1.0'

set :application, 'Gandalf'
set :repo_url, 'git@github.com:ZeusWPI/Gandalf.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :branch, 'master'
set :deploy_to, '/home/gandalf/production'

# Default value for :linked_files is []
set :linked_files, %w(config/database.yml config/secrets.yml)

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
#
set :log_level, :debug

# Default value for keep_releases is 5
# set :keep_releases, 5

set :passenger_restart_with_touch, true

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app) do
      with rails_env: fetch(:rails_env) do
        execute "touch #{current_path}/tmp/restart.txt"
      end
    end
    invoke 'delayed_job:restart'
  end

  after :publishing, :restart
end
