require 'spec_helper'

describe "Authentication" do
	let(:user) { FactoryGirl.create(:user) }
	let(:wrong_user) { FactoryGirl.create(:user, :email => "wrong@email.com") }
	subject { page }
	
	describe "signin page" do
		before {visit signin_path}
		it { should have_selector('h1',    :text => 'Sign in') }
		it { should have_selector('title', :text => 'Sign in') }
		describe "Signin with invalid information" do
			before { click_button "Sign In" }
			it { should have_selector('div.alert.alert-error', :text => "Invalid") }
			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-error') }
			end
		end
		describe "When Email is valid but password is not" do
			before do
				fill_in "Email", :with =>user.email
				fill_in "Password", :with =>'failure'
				click_button 'Sign In'
			end
			it { should have_selector('div.alert.alert-error', :text => "Email found but password is invalid") }
		end
		describe "Signin with valid inforamtion" do
			before { login_user(user) }
			it { should have_link('Sign out') }
			it { should have_link('Users',    :href=> users_path) }
      it { should have_link('Profile',  :href=> user_path(user)) }
      it { should have_link('Settings', :href=> edit_user_path(user)) }
      it { should have_link('Sign out', :href=> signout_path) }
			
			describe "when clicking signout" do
				before { click_link "Sign out" }
				it { should have_link('Sign in') }
				it { should_not have_link('Settings', :url=> edit_user_path(user)) }
				it { should_not have_link('Signout', :url=> signout_path) }
			end	
		end
	end

	describe "authorization" do
		describe "for non-signed-in users" do
			describe "in the Users controller" do
				describe "visiting the user index page" do
					before {visit users_path}
					it {should have_selector('title', :text => 'Sign in')}
				end
				describe "visiting the edit page" do
					before { visit edit_user_path(user) }
					it { should have_selector('title', :text => 'Sign in') }
					describe "after signing in" do
						before do
							fill_in "Email", :with =>user.email
							fill_in "Password", :with =>user.password
							click_button 'Sign In'
						end
						it { should have_selector('title', :text => "Edit user")}
					end
				end

				describe "submitting to the update action" do
					before { put user_path(user) }
					specify { response.should redirect_to(signin_path) }
				end
			end
		end
		describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { login_user non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }        
      end
    end
	end

	describe "as wrong user" do
		before { login_user(user) }
		describe "visiting Users#edit page" do
      before { visit edit_user_path(wrong_user) }
      it { should_not have_selector('title', :text => 'Edit user') }
    end
		describe "submitting a PUT request to the Users#update action" do
			before { put user_path(wrong_user) }
			specify { response.should redirect_to(root_path) }
		end
	end

end