require 'spec_helper'
describe "User Pages" do
	subject {page}
	describe "profile page" do
  		let(:user) { FactoryGirl.create :user }
 		before { visit user_path(user) }

  		it { should have_selector('h1',    :text => user.name) }
  		it { should have_selector('title', :text => user.name) }
	end

	describe "signup Page" do
		before { visit signup_path}
		let(:submit) { "Create my account"}
		describe "When form has invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end
			
		end
		describe "When form is valid" do
			before do
				valid_signup
			end
			it "should add a user to the database" do
				expect { click_button submit }.to change(User, :count).by(1)
			end	
		end
		describe "When signup information is invalid" do
			before do
				click_button submit
				fill_in "Name", :with => "Joe"
				fill_in "Email", :with => "matt.com"
			end
			it {should have_content("Name can't be blank")}
			it {should_not have_content("Password digest can't be blank")}
			it {should have_content("Email is invalid")}
			it {should have_selector('div.alert')}
		end	
	end

	describe "edit page" do
		let(:user) { FactoryGirl.create :user }

 		before do
 			login_user(user)
 			visit edit_user_path(user)
 		end
		it {should have_selector("h1", :text => "Update your profile")}
	end

end
