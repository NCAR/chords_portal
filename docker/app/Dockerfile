FROM ruby:2.2 
MAINTAINER martinc@ucar.edu

# Install apt based dependencies required to run Rails as 
# well as RubyGems. As the Ruby image itself is based on a 
# Debian image, we use apt-get to install those.
RUN apt-get update && apt-get install -y \
  build-essential \
  nodejs \
  mysql-client \
  dos2unix \
  nginx \
  sendmail

# Configure the main working directory. This is the base 
# directory used in any further RUN, COPY, and ENTRYPOINT 
# commands.
RUN mkdir -p /chords 
WORKDIR /chords

# Copy the Gemfile as well as the Gemfile.lock and install 
# the RubyGems. This is a separate step so the dependencies 
# will be cached unless changes to one of those two files 
# are made.
COPY Gemfile Gemfile.lock ./ 
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy the main application.
COPY . ./

# Bake the assets (for production mode) into the image
RUN mkdir -p /chords/log && RAILS_ENV=production bundle exec rake assets:precompile

# Customize the nginx configuration
COPY ./nginx_default.conf /etc/nginx/sites-available/default

# Create the CHORDS environment value setting script chords_env.sh.
# Use this bit of magic to invalidate the cache so that the command is run.
ADD http://www.random.org/strings/?num=10&len=8&digits=on&upperalpha=on&loweralpha=on&unique=on&format=plain&rnd=new cache_invalidator
RUN /bin/bash -f create_chords_env_script.sh > chords_env.sh && chmod a+x chords_env.sh

# Remove artifacts that are not needed. The docker image will only shrink
# however if the docker build command is run with the --squash option
RUN rm -rf .git log/* tmp/*

# Expose port 80 to the Docker host, so we can access it 
# from the outside.
EXPOSE 80

# Configure an entry point, so we don't need to specify 
# "bundle exec" for each of our commands.
ENTRYPOINT ["bundle", "exec"]

# Start CHORDS
CMD ["/bin/bash", "-f", "chords_start.sh"]
