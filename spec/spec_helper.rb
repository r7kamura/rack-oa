require "rack/oa"
require "rack/test"
require "rspec/json_matcher"

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.include RSpec::JsonMatcher
end
