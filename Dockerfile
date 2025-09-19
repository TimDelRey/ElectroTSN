# FROM ruby:3.3

# RUN apt-get update -qq && \
#   apt-get install -y build-essential libpq-dev netcat-openbsd && \
#   rm -rf /var/lib/apt/lists/*

# WORKDIR /app

# COPY Gemfile* ./
# RUN bundle install

# COPY . .

# ENV RAILS_ENV=development

# CMD ["bin/rails", "server", "-b", "0.0.0.0"]
