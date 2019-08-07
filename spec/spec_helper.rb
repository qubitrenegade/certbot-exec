# frozen_string_literal: true
require 'chefspec'
require 'chefspec/berkshelf'

def base_dir
  File.dirname(File.dirname(__FILE__))
end

def default_attrs_from_file
  default = {}
  # Is it _really_ a security risk?  It's just in the test...
  # I feel like it's an acceptable risk since what we're testing is really these values...
  # also, good way to test the result of "ovverride" attributes at the `default` level?
  # Intentionally not diabling rubocop/cookstyle errors.
  eval(
    File.read(
      File.join(base_dir, 'attributes', 'default.rb')
    )
  )
  default
end

at_exit { ChefSpec::Coverage.report! }
