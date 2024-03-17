FROM ruby:3.3.0

ENV RAILS_ENV=production

RUN apt update && apt install -y nodejs cron

WORKDIR /app

COPY ./Gemfile ./Gemfile.lock /app/

RUN gem install bundler
RUN bundle install

COPY . /app

RUN bundle exec rails assets:precompile

CMD bundle exec rails s -b 0.0.0.0
