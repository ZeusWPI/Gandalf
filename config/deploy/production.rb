server 'events.ugent.be', user: 'events', roles: %w{web app db},
  ssh_options: {
    forward_agent: true,
    auth_methods: ['publickey'],
    port: 2222
  }

set :rails_env, 'production'
set :rbenv_type, :system
set :rbenv_ruby, File.read('.ruby-version').strip
