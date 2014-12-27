#!/bin/bash
#
# rbenv version

set -e

source /usr/local/share/chruby/chruby.sh
RUBIES=(~/.rbenv/versions/* ~/.rubies/*)

function run {
  chruby $RUBY_VERSION

  for version in 2.2.6 2.4.4 2.5.4 2.6.3; do
    echo "Running bundle exec ruby test/mail_test.rb against mail $version using $RUBY_VERSION..."
    rm -f Gemfile.lock
    MAIL_GEM_VERSION=$version bundle install
    MAIL_GEM_VERSION=$version bundle exec ruby -Itest test/mail_test.rb
  done

  exit

  gem list --local bundler | grep bundler || gem install bundler --no-ri --no-rdoc

  RAILS_VERSIONS=(3.2.21 4.2.0)

  for version in ${RAILS_VERSIONS[@]}; do
    rm -f Gemfile.lock
    echo "Running bundle exec rspec spec against actionmailer $version using $RUBY_VERSION..."
    if test $version = "3.2.21"; then
      mail_gem_version=2.5.4
    else
      mail_gem_version=2.6.3
    fi
    MAIL_GEM_VERSION=$mail_gem_version MAIL_ISO_2022_JP_RAILS_VERSION=$version bundle install
    MAIL_GEM_VERSION=$mail_gem_version MAIL_ISO_2022_JP_RAILS_VERSION=$version bundle exec rake test_all
  done
}

export RUBY_VERSION=1.9.3
run

export RUBY_VERSION=2.0.0
run

echo 'Success!'
