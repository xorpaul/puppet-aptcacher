require 'spec_helper'
describe 'aptcacher' do
  context 'with default values for all parameters' do
    it { should contain_class('aptcacher') }
  end
end
