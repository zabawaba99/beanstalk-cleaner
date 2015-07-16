FROM  ruby:2.2
MAINTAINER  Steven Berlanga<zabawaba99@gmail.com>

ADD . cleaner/
WORKDIR cleaner
RUN bundle install

CMD bundle exec ruby cleaner.rb
