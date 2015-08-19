require 'spec_helper'
describe 'nodecellar' do

  context 'with defaults for all parameters' do
    it { should contain_class('nodecellar') }
  end
end
