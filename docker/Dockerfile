FROM ruby:2.5-slim
WORKDIR /usr/src/app

LABEL org.squib.url=http://squib.rocks \
      org.squib.github=https://github.com/andymeneely/squib

RUN apt-get update && \
    apt-get install -y \
    libgirepository1.0-dev

RUN gem install nokogiri -v 1.8.4 -- \
    --with-xml2-include=/usr/include/libxml2/libxml \
    --with-xml2-lib=/usr/lib64/ \
    --with-xslt-include=/usr/include/libxslt \
    --with-xslt-lib=/usr/lib64/

RUN gem pristine nokogiri -v 1.8.4

RUN gem install squib

RUN apt-get clean && \
    apt-get autoremove --purge
