#!/bin/bash
#
# rbenv version

set -e

function run {
  for version in 2.2.6 2.4.4 2.5.4 2.6.1 HEAD; do
    rm -f Gemfile.lock
    MAIL_GEM_VERSION=$version bundle install
    MAIL_GEM_VERSION=$version bundle exec ruby -Itest test/mail_test.rb
  done

  gem list --local bundler | grep bundler || gem install bundler --no-ri --no-rdoc

  if test $RBENV_VERSION = "1.8.7-p371"; then
    RAILS_VERSIONS=(3.2.13)
  else
    RAILS_VERSIONS=(3.2.13 4.0.6 4.1.2)
  fi

  for version in ${RAILS_VERSIONS[@]}; do
    rm -f Gemfile.lock
    echo "Running bundle exec rspec spec against actionmailer $version..."
    MAIL_GEM_VERSION=2.5.4 MAIL_ISO_2022_JP_RAILS_VERSION=$version bundle install
    MAIL_GEM_VERSION=2.5.4 MAIL_ISO_2022_JP_RAILS_VERSION=$version bundle exec rake test_all
  done
}

export RBENV_VERSION=1.8.7-p371
run

export RBENV_VERSION=1.9.3-p547
run

export RBENV_VERSION=2.0.0-p481
run

export RBENV_VERSION=2.1.2
run

echo 'Success!'
