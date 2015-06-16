require_relative 'test_helper'

class MockSequelApplication < Ramverk::Application
  include Ramverk::Sequel

  config.sequel.connection 'sqlite://test.db'
end

describe Ramverk::Sequel do

  it 'stores the config' do
    MockSequelApplication.config.sequel.connection.must_equal 'sqlite://test.db'
  end
end
