require 'spec_helper'

require 'veritas-do-adapter'
require 'do_postgres'

require 'db_setup'

RSpec.configure do |config|

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.after(:all) do
    DM_ENV.reset
  end

  config.before do
    DM_ENV.finalize
  end
end
