FactoryGirl.define do
  
  #create user
  factory :user do
  	sequence(:name) { |n| "Person Name #{n}" }
  	sequence(:email) { |n| "example_#{n}@example.com" }
  	password "foobar"
  	password_confirmation "foobar"
   	
   	factory :admin do
    	admin true
  	end
	end

	#create post for user
	factory :micropost do
  	content "Lorem ipsum"
  	user
	end

end