require 'spec_helper'
describe "Static pages" do
let(:base_title){ "Ruby on Rails Tutorial Sample App |"}
 
  subject {page}
  describe "Home page" do
    before {visit root_path}
    it {should have_selector('h1', :text => 'Home')}
    it {should have_selector('title', :text=>"#{base_title} Home")} 
  end

  describe "Help page" do
    before {visit help_path}
    it { should have_selector('h1', :text=> 'Help')}
    it { should  have_selector('title', :text => "#{base_title} Help")}
  end
  
  describe "About page" do
    before {visit about_path}
    it {should have_selector('h1', :text => 'About')}
    it {should have_selector('title', :text => "#{base_title} About")}
  end

  describe "Contact Page" do
    before {visit contact_path}
  	it {should have_selector('title', :text=>"#{base_title} Contact")}
  	it {page.should have_selector('h1',:text=>"Contact")}
  end
end