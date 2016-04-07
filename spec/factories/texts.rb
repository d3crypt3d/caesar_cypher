FactoryGirl.define do
  factory :text do
    data "MyString"
    frequency 1
    initialize_with { Text.send :new }
  end
end
