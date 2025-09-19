FROM ruby:3.4.3-slim-bookworm

WORKDIR /usr/src/ruby-boilerplate

RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y \
  libvips \
  libvips-tools \
  htop \
  git \
  vim \
  curl \
  wget \
  telnet \
  build-essential \
  pkg-config \
  ghostscript \
  postgresql-client \
  imagemagick \
  libmagick++-dev \
  libjemalloc2 \
  libpq-dev \
  librdkafka++1 \
  librdkafka1 \
  librdkafka-dev \
  dumb-init && \
  rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV RUBY_YJIT_ENABLE=1 \
  RAILS_SERVE_STATIC_FILES=true \
  RAILS_ENV=production \
  RACK_ENV=production \
  BUNDLE_DEPLOYMENT=1 \
  BUNDLE_WITHOUT=development:test \
  BUNDLE_PATH=/usr/local/bundle \
  DISABLE_SPRING=true \
  BUNDLER_VERSION=2.6.7 \
  WEB_CONCURRENCY=3 \
  LD_PRELOAD=libjemalloc.so.2 \
  MALLOC_CONF=background_thread:true,metadata_thp:auto,dirty_decay_ms:5000,muzzy_decay_ms:5000,narenas:2 \
  TZ=Asia/Jakarta

RUN gem install foreman bundler:${BUNDLER_VERSION}

COPY .ruby-version Gemfile Gemfile.lock ./
RUN bundle install --retry 3
RUN rm -rf ~/.bundle/ ${BUNDLE_PATH}/ruby/*/cache ${BUNDLE_PATH}/ruby/*/bundler/gems/*/.git

COPY . .
RUN bundle exec bootsnap precompile --gemfile app/ lib/

RUN chmod +x /usr/src/ruby-boilerplate/script/deploy.sh
RUN echo 'alias rails="bundle exec rails"' >> ~/.bashrc
RUN mv /etc/ImageMagick-6/policy.xml /etc/ImageMagick-6/policy.xml.off
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

HEALTHCHECK --interval=5m --timeout=5s --retries=3 \
  CMD curl -f http://127.0.0.1:3000/up || exit 1

EXPOSE 3000
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/src/ruby-boilerplate/script/deploy.sh"]
