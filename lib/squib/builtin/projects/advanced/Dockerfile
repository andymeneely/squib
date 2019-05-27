FROM andymeneely/squib:latest

# If you add additional gems, this will run those installations there
COPY Gemfile /usr/src/app/
RUN gem install bundler && \
    cd /usr/src/app && \
    bundle install

# Add in custom font files
RUN mkdir ~/.fonts
COPY fonts/*.otf /usr/share/fonts/
COPY fonts/*.ttf /usr/share/fonts/
RUN fc-cache -f -v /usr/share/fonts/
