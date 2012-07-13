require 'spec_helper'
describe "User Pages" do
	subject {page}
	describe "profile page" do
  	# Code to make a user variable
  		let(:user) { FactoryGirl.create :user }
 		before { visit user_path(user) }

  		it { should have_selector('h1',    :text => user.name) }
  		it { should have_selector('title', :text => user.name) }
  		it { should have_selector('ul.nav li a', :text => "Sign out")}
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
				fill_in "Name", :with => "Matt Witek"
				fill_in "Email", :with => "matt@mwitekdesign.com"
				fill_in "Password", :with => "foobar"
				fill_in "Confirmation", :with => "foobar"
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

end
