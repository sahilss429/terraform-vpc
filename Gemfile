source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :test do
  gem "rake-terraform"
  gem "rake"
  gem "rspec"
  gem "metadata-json-lint"
  gem "rspec-puppet-facts"
  gem 'simplecov', '>= 0.11.0'
  gem 'simplecov-console'

end

group :development do
  gem "puppet-blacksmith"
end

group :system_tests do
  gem "beaker"
  gem "beaker-rspec"
  gem "beaker-puppet_install_helper"
end
