FROM ruby:2.7

WORKDIR /app

COPY Gemfile .
RUN bundle install

COPY realtime_viewer.rb .
COPY recompute_from_storage.rb .