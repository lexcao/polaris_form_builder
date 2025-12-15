# frozen_string_literal: true

def unbundled(command)
  env_unset = %w[
    BUNDLE_BIN_PATH
    BUNDLE_GEMFILE
    BUNDLER_VERSION
    GEM_HOME
    GEM_PATH
    RUBYOPT
  ].map { |key| "-u #{key}" }.join(' ')

  "env #{env_unset} #{command}"
end

CI.run do
  step 'Bundle: root', unbundled('bundle install --jobs 4 --retry 3')
  step 'Bundle: dummy', unbundled('bundle install --jobs 4 --retry 3 --gemfile test/dummy/Gemfile')
  step 'Bundle: playground', unbundled('bundle install --jobs 4 --retry 3 --gemfile app/playground/Gemfile')

  step 'Style: Ruby', unbundled('bin/rubocop -f github')
  step 'Tests', unbundled('bundle exec rake test')

  failure 'Signoff: CI failed.', 'Fix the issues and try again.' unless success?
end
