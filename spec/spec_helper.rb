# frozen_string_literal: true
require 'chefspec'
require 'chefspec/berkshelf'

def base_dir
  File.dirname(File.dirname(__FILE__))
end

at_exit { ChefSpec::Coverage.report! }
