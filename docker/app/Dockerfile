FROM ruby:2.7.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev libv8-dev nodejs cmake

# Set an environment variable where the Rails app is installed to inside of Docker image:
ENV RAILS_ROOT /var/www/mamo-assignment
RUN mkdir -p $RAILS_ROOT

# Set working directory, where the commands will be ran:
WORKDIR $RAILS_ROOT

# Setting env up
ENV RAILS_ENV='development'
ENV RACK_ENV='development'

# Adding gems
COPY Gemfile* ./
RUN gem install bundler:"$(tail -n 1 Gemfile.lock | xargs)"
RUN bundle check || bundle install

# Adding project files
COPY . .

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
