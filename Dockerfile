# Install system dependencies, including Chrome.
# Use an official Ruby runtime as a parent image
FROM ruby:3.1.3

# Set the working directory in the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock to the container
COPY Gemfile Gemfile.lock ./

# Install project dependencies
RUN bundle install

# Copy the rest of the application code to the container
COPY . .

# Set environment variables
ENV RAILS_ENV=production
ENV RAILS_MASTER_KEY=bd0f5da178ddff48d1688fd0e299311b

# Precompile assets (if using the asset pipeline)
RUN bundle exec rake assets:precompile

# Start your Rails application
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]


RUN apt-get update -qq && apt-get install -y \
    curl \
    unzip \
    libnss3 \
    libgconf-2-4 \
    libxi6 \
    libxrender1 \
    libxrandr2 \
    libxcursor1 \
    libxss1 \
    libxtst6 \
    libasound2 \
    && curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update -qq && apt-get install -y google-chrome-stable
