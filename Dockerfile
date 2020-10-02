# This is the official Squib Docker image. 
# 
FROM ruby:2.6-alpine
WORKDIR /usr/src/app

LABEL org.squib.url=http://squib.rocks \
      org.squib.github=https://github.com/andymeneely/squib

# This works, but it really bloats the image
RUN apk --no-cache --update --upgrade add  \
    build-base \
    cairo-dev \
    pango-dev \
    gobject-introspection-dev \
    gdk-pixbuf-dev \
    librsvg-dev

RUN gem install squib

# Remove some of the dev tools
RUN apk del build-base

RUN apk --no-cache --update --upgrade add \
    ttf-opensans

# Just for devving on
# CMD ["sh"]
# RUN apk --no-cache add ncdu



