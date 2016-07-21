FROM jenkins:latest
USER root
RUN apt-get update && apt-get install sudo 
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
ENV RUBY_MAJOR="2.2" \
    RUBY_VERSION="2.2.2" \
    DB_PACKAGES="libsqlite3-dev" \
    RUBY_PACKAGES="ruby2.2 ruby2.2-dev" \
    BUNDLER_VERSION="1.10" \
    GEM_VERSION="2.0.14"

ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME" \
        BUNDLE_BIN="$GEM_HOME/bin" \
        BUNDLE_SILENCE_ROOT_WARNING=1 \
        BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $BUNDLE_BIN:$PATH

RUN echo 'gem: --no-document' >> /.gemrc

RUN mkdir -p /tmp/ruby \
  && curl -L "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.bz2" \
      | tar -xjC /tmp/ruby --strip-components=1 \
  && cd /tmp/ruby \
  && ./configure --disable-install-doc \
  && make \
  && make install \
  && gem update --system \
  && rm -r /tmp/ruby

RUN gem update --system "$GEM_VERSION"
RUN gem install --no-document bundler --version "$BUNDLER_VERSION"
RUN apt-get update && apt-get install -y libmysqlclient-dev mysql-client postgresql-client libsqlite3-dev git tmux --no-install-recommends && rm -rf /var/lib/apt/lists/*