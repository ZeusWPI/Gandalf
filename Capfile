# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require 'capistrano/docker'
require 'capistrano/docker/migration'

before 'docker:deploy:compose:start', 'docker:compose:down'
