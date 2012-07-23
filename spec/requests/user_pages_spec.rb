require 'spec_helper'

describe "User Pages" do
	let(:user) { FactoryGirl.create :user }
	subject { page }
  describe 'visiting /new while logged in' do
  	before do
  		login_user(user)
  		visit new_user_path
  	end
  	it { should have_selector('title', :text=> user.name) }
  	it {should_not have_selector('button', :text=> "Create my account" )}
  end
	describe "index" do
		before(:all) { 30.times { FactoryGirl.create(:user) } }
		after(:all) { User.delete_all }
		before(:each) do
			login_user(user)
			visit users_path
		end
		it {should have_selector('title', :text => "All Users")}
		it {should have_selector('h1', :text => "All Users")}
		describe "pagination" do
      it { should have_selector('div.pagination') }
      it "should list each user" do
        User.paginate(:page => 1).each do |user|
          page.should have_selector('li', :text => user.name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link('delete') }
      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          login_user admin
          visit users_path
        end
        it { should have_link('delete', :href => user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', :href => user_path(admin)) }
      end
    end 
	end

	describe "profile page" do
		before { visit user_path(user) }
			it { should have_selector('h1',    :text => user.name) }
			it { should have_selector('title', :text => user.name) }
	end
	
	describe "Edit Page" do
		before do 
			login_user(user)
			visit edit_user_path(user)
		end
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
	describe "admin accessible attributes" do
    it "should not allow access :admin" do
      expect do
        User.new(:admin => true)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
end
