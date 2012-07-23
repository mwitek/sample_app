FactoryGirl.define do
  factory :user do
  	sequence(:name) { |n| "Person Name #{n}" }
  	sequence(:email) { |n| "example_#{n}@example.com" }
  	password "foobar"
  	password_confirmation "foobar"
   	factory :admin do
    	admin true
  	end
  end
end