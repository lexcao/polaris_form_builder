# frozen_string_literal: true

CI.run do
  step 'Bundle: root', 'bundle install'
  step 'Bundle: dummy', 'env BUNDLE_GEMFILE=test/dummy/Gemfile bundle install'
  step 'Bundle: playground', 'env BUNDLE_GEMFILE=app/playground/Gemfile bundle install'

  step 'Style: Ruby', 'bin/rubocop -f github'
  step 'Tests', 'bundle exec rake test'

  failure 'Signoff: CI failed.', 'Fix the issues and try again.' unless success?
end
