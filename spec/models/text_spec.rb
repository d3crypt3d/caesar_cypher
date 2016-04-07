require 'rails_helper'

RSpec.describe Text do
  subject { FactoryGirl.build(:text) }

  it { should respond_to(:data) }
  it { should respond_to(:frequency) }
end
