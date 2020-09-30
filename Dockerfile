FROM ruby:2.2.2

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN rake db:migrate
RUN rake db:seed

CMD ["rails", "s", "-b", "0.0.0.0"]
