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
set :linked_files, %w{.env config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
#
set :log_level, :debug

# Default value for keep_releases is 5
# set :keep_releases, 5

# capistrano-docker specific
set :docker_command, "podman"
set :docker_compose, true
set :docker_compose_command, "podman-compose"
