FROM ruby:2.7

WORKDIR /app

COPY Gemfile .
RUN bundle install

COPY mirror_to_postgres.rb .
