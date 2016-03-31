FactoryGirl.define do
  factory :english_text, class: Text do
    alphabet ('a'..'z').to_a
    shift 4
  end
end
