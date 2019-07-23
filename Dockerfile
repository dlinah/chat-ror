FROM ruby:2.5.0
RUN apt-get update -qq && apt-get install -y build-essential
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
ENV BUNDLER_VERSION 2.0.2
RUN gem install bundler -v 2.0.2
RUN bundle -v
RUN bundle install
COPY . /app
ENV RAILS_ENV production
# Add a script to be executed every time the container starts.
COPY start.sh /usr/bin/
RUN chmod +x /usr/bin/start.sh
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]