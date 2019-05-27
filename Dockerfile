FROM ruby:2.5-alpine
WORKDIR /usr/src/app

LABEL org.squib.url=http://squib.rocks \
      org.squib.github=https://github.com/andymeneely/squib

RUN apk --no-cache add --update \
    ruby-dev \
    build-base \
    libxml2-dev \
    libxslt-dev \
    pcre-dev \
    libffi-dev \
    cairo

# Just for devving on
COPY . /app

CMD ["sh"]

# RUN gem install \
#     squib \
#     -- --use-system-libraries

# NOTE: STILL UNDER DEVELOPMENT! Don't use this just yet.
