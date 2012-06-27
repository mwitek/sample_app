require 'spec_helper'
describe "UserPages" do
  subject {page}	
  let(:base_title){ "Ruby on Rails Tutorial Sample App |"}
  describe "Signup Page" do
  	before {visit signup_path}
  	it {should have_selector('h1', :text => 'New')} 
  	it {should have_selector('title', :text=>"#{base_title} New")} 
  end
end
