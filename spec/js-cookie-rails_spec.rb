require 'spec_helper'

describe Dummy::Application do

  it 'should find `js.cookie` as an asset' do
    described_class.assets['js.cookie'].should_not be_nil
  end

  it 'should have the correct body for `js.cookie`' do
    described_class.assets['js.cookie'].body.should include('js-cookie')
  end
end
