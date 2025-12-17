FROM ruby:3.4.7-alpine

RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    tzdata \
    nodejs \
    yarn \
    linux-headers \
    gcompat \
    libxml2-dev \
    libxslt-dev \
    openssl-dev \
    zlib-dev \
    gmp-dev

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development:test"

WORKDIR /app

# Copy Gemfiles first for caching
COPY Gemfile Gemfile.lock ./

# Install gems with specific psych version fix
RUN bundle config build.psych --with-opt-dir=/usr && \
    bundle install --jobs=2 --retry=3

COPY . .

RUN adduser -D -u 1000 app && \
    chown -R app:app /app

USER app

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
