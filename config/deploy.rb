# config valid only for Capistrano 3.1
# lock '3.1.0'

set :application, 'Gandalf'
set :repo_url, 'git@github.com:ZeusWPI/Gandalf.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :branch, 'capistrano-docker'
set :deploy_to, '/home/gandalf/production'

# Default value for :linked_files is []
set :linked_files, []

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

set :copied_files, %w{.env config/database.yml}

module Capistrano
  module DSL
    module Paths
      def copied_files(parent)
        paths = fetch(:copied_files)
        join_paths(parent, paths)
      end

      def copied_file_dirs(parent)
        map_dirnames(copied_files(parent))
      end
    end
  end
end

namespace :deploy do
  namespace :check do
    after :linked_files, :copied_files

    task :copied_files do
      on release_roles :all do
        execute :mkdir, "-p", copied_file_dirs(release_path)

        fetch(:copied_files).each do |file|
          target = release_path.join(file)
          source = shared_path.join(file)
          execute :cp, source, target
        end
      end
    end
  end
end
