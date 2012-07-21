require 'spec_helper'

describe "User Pages" do
	subject { page }
	describe "profile page" do
  		let(:user) { FactoryGirl.create :user }
 		before { visit user_path(user) }

  		it { should have_selector('h1',    :text => user.name) }
  		it { should have_selector('title', :text => user.name) }
	end
	
	describe "Edit Page" do
		let(:user) { FactoryGirl.create :user }
		before { visit edit_user_path(user)}
		describe "page" do
      it { should have_selector("h1", :text => "Update your profile") }
			it { should have_link("change", :url => "http://gravatar.com/emails") }
      it { should have_selector('title', :text => "Edit user") }
    end
    	describe "with invalid information" do
	  		before { click_button "Save changes" }
	  		it { should have_content('error') }
	  	end

	  	describe "with valid information" do
	  		let(:new_name) { "New Name" }
	  		let(:new_email) { "newemail@example.com" }
	  		before do
	  			fill_in "Name", :with => new_name
	  			fill_in "Email", :with => new_email
	  			fill_in "Password", :with => user.password
	  			fill_in "Confirmation", :with => user.password
	  			click_button "Save changes"
	  		end
	  			it { should_not have_content('error') }
	  			it { should have_selector('title', :text=> new_name) }
	  			it { should have_selector('.alert-success', :text=> "Great job #{new_name}!  Your profile has been updated.")}
	  			specify { user.reload.name.should == new_name }
	  			specify { user.reload.email.should == new_email }
	  	end
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
			before { valid_signup }
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
			it { should have_content("Name can't be blank") }
			it { should_not have_content("Password digest can't be blank") }
			it { should have_content("Email is invalid") }
			it { should have_selector('div.alert') }
		end	
	end
end
