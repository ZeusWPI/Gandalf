FROM ruby:3.0.4

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN rake db:migrate
RUN rake db:seed

CMD ["rails", "s", "-b", "ssl://0.0.0.0:8080?key=server.key&cert=server.crt"]
