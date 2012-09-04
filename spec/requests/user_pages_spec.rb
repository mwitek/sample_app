require 'spec_helper'

describe "User Pages" do
	let(:user) { FactoryGirl.create :user }
	let!(:post1){ FactoryGirl.create :micropost, :user_id=> user.id, :content => "kowabunga" }
	let!(:post2){ FactoryGirl.create :micropost, :user_id=> user.id, :content => "dude" }
	let(:other_user) { FactoryGirl.create :user }
	let!(:other_user_post1) { FactoryGirl.create(:micropost, :user => other_user, :content => "cheerios") }
	let!(:other_user_post1) { FactoryGirl.create(:micropost, :user => other_user, :content => "chips") }

	subject { page }

	describe "visiting follows/followers pages" do
		before { login_user(user) ; user.follow!(other_user) }
		describe "follows path" do
			before { visit following_user_path(user) }
		  it { should have_selector('title', :text => 'Following') }
      it { should have_selector('h3', :text => 'Following') }
      it { should have_link(other_user.name, :href => user_path(other_user)) }
    end
    describe "followers path" do
    	before { visit followers_user_path(other_user) }
    	it { should have_selector('title', :text => 'Followers') }
    	it { should have_selector('h3', :text => 'Followers') }
    	it { should have_link(user.name, :href => user_path(user)) } 
    end
	end
  
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
		before do
			login_user(user)
			visit user_path(user)
		end
			it { should have_selector('h1',    :text => user.name) }
			it { should have_selector('title', :text => user.name) }
			describe "micropost on page" do
				it { should have_content(post1.content) }
				it { should have_content(post2.content) }
				it { should have_content(user.microposts.count) }
				it { should have_link('delete') }
			end
		describe "follow/unfollow buttons" do
      before { login_user user }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_selector('input', :value => 'Unfollow') }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_selector('input', :value => 'Follow') }
        end
      end
    end  
	end

	describe "visit another users profile page" do
		before do
			login_user(user)
			visit user_path(other_user)
		end
		it { should have_content(other_user_post1.content)}
		it { should_not have_link('delete') }
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
