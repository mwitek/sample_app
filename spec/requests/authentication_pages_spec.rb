require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before {visit signin_path}
    it { should have_selector('h1',    :text => 'Sign in') }
    it { should have_selector('title', :text => 'Sign in') }
    describe "Signin with invalid information" do
    	before {click_button "Sign In"}
    	it {should have_selector('div.alert.alert-error', :text => "Invalid")}
        describe "after visiting another page" do
            before { click_link "Home" }
            it { should_not have_selector('div.alert.alert-error') }
        end
    end
    describe "When Email is valid but password is not" do
      let(:user) {FactoryGirl.create(:user)}
      before do
        fill_in "Email", :with =>user.email
        fill_in "Password", :with =>'failure'
        click_button 'Sign In'
      end
      it {should have_selector('div.alert.alert-error', :text => "Email found but password is invalid")}
    end

    describe "Signin with valid inforamtion" do
    	let(:user) {FactoryGirl.create(:user)}
    	before do
    		fill_in "Email", :with => user.email
    		fill_in "Password", :with => user.password
    		click_button 'Sign In'
    	end
      it { should have_link('Sign out') }
      describe "when clicking signout" do
          before {click_link "Sign out"}
          it {should have_link('Sign in')}
        end	
    end
    
  end
end