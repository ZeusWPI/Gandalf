FROM ruby:3.0.4

ENV RAILS_ENV=production

RUN apt update && apt install -y nodejs

WORKDIR /app

COPY ./Gemfile ./Gemfile.lock /app/

RUN gem install bundler
RUN bundle install

COPY . /app
ADD .env /app/
ADD config/database.yml /app/config/

RUN bundle exec rails assets:precompile

CMD bundle exec rails s -b 0.0.0.0
