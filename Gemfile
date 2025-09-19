# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

gem "rails", "~> 7"
gem "pg", "~> 1"
gem "puma", "~> 6"
gem "jbuilder"
gem "sass-rails"
gem "turbolinks"
gem "bootsnap", require: false

group :development, :test do
  gem "byebug"
  gem "database_cleaner-active_record"
  gem "factory_bot_rails"
  gem "rails-controller-testing"
  gem "rspec-rails"
  gem "benchmark-ips"
end

group :production do
  gem "stackprof"
  gem "sentry-ruby"
  gem "sentry-rails"
end

group :development do
  gem "listen"
  gem "spring"
  gem "spring-watcher-listen"
  gem "web-console"
  gem "rubocop-rails-omakase", require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "simplecov", require: false
  gem "webdrivers"
end

gem "tzinfo-data"

gem "dotenv-rails"
gem "rest-client"
# gem "faraday"
# gem "faraday-multipart"

# set up API grape and swagger doc
gem "grape", "~> 2"
gem "grape-entity"
gem "grape-middleware-logger"
gem "grape_logging"
gem "hashie-forbidden_attributes"

# documentation
gem "grape-swagger"
gem "grape-swagger-rails"

# pagination
gem "api-pagination"
gem "kaminari"
gem "pagy"
gem "kaminari-mongoid"

# delayed job
gem "delayed_job_active_record"

gem "daemons"

# soft delete
gem "acts_as_paranoid"

gem "rubyzip", require: "zip"

gem "url_safe_base64"

# schedulers
gem "rufus-scheduler"

gem "json"

gem "racecar"

# pdf
gem "wicked_pdf"
gem "wkhtmltoimage-binary", "0.12.4"
gem "wkhtmltopdf-binary", "0.12.4"

gem "prawn"
gem "prawn-qrcode"
gem "pdf-reader"

# qr
gem "barby"
gem "rqrcode"

# tiff
gem "imgkit"
gem "mini_magick"
gem "rmagick"

gem "rollbar"
gem "telegram-bot-ruby"

# xlsx
gem "caxlsx"

gem "mimemagic"
gem "mongoid"

# email
gem "mandrill_mailer"
gem "MailchimpTransactional"
gem "hexapdf"
gem "image_size"

gem "dcidev_utility"
gem "ruby-kafka"

gem "jwt"
gem "aes-everywhere"
gem "net-http"
gem "net-smtp"
gem "net-imap"
gem "uri"

gem "sidekiq", "~> 7"
gem "sidekiq-delay_extensions"
gem "sidekiq-unique-jobs"
gem "redis-namespace"
gem "redis-rails"

gem "delayed_job_web"
gem "google-cloud-firestore"
gem "matrix"

gem "distribute_reads"
gem "datadog"
gem "lograge"

gem 'i18n'
gem 'hiredis'
gem "hiredis-client"