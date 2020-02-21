# https://blog.codeship.com/running-rails-development-environment-docker/

#For new application
# docker-compose -f docker.compose.v3.yml run app rails new . --force --database=postgresql

# https://blog.codeship.com/running-rails-development-environment-docker/
FROM ruby:2.5.3
MAINTAINER Fateh Singh <fatehsingh.sunny5@gmail.com>

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
#
# RUN apt-get update && apt-get install -y \
#   build-essential \
#   nodejs \
#   libpq-dev
# RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN apt-get update -qq && \
		curl -sL https://deb.nodesource.com/setup_10.x | bash -  &&\
    apt-get install -y nodejs \
                       vim \
                       postgresql-client \
                       --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
RUN mkdir -p /app
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files are made.
COPY Gemfile Gemfile.lock ./
#Run bundle update
RUN gem install bundler && bundle install --jobs 20 --retry 5
# First time
#Run bundle install

# Copy the main application.
COPY . ./

# Expose port 3000 to the Docker host, so we can access it
# from the outside.
EXPOSE 3000

# Configure an entry point, so we don't need to specify
# "bundle exec" for each of our commands.
ENTRYPOINT ["bundle", "exec"]

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
# CMD ["rails", "server", "-b", "0.0.0.0"]
