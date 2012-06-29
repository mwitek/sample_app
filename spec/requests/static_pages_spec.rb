require 'spec_helper'
describe "Static pages" do
  
  subject {page}
  
  before(:all) do
      @action = puts :action
  end
  
  shared_examples_for 'all static pages' do
    it {should have_selector('h1', :text => @action)}
    it {should have_selector('title', :text=>"#{base_title} #{@action}")}
    it "should have the right links on the layout" do
      click_link "About"
      click_link "Help"
      click_link "Home"
      click_link "sample app"
      click_link "Sign up now!"
      page.should have_selector 'title', :text=>"#{base_title} #{@action}"
    end 
  end

  let(:base_title){ "Ruby on Rails Tutorial Sample App |"}
 
  describe "Home page" do
    before {visit root_path}
    it_should_behave_like 'all static pages'
  end

  describe "Help page" do
    before {visit help_path}
    it_should_behave_like 'all static pages'
  end
  
  describe "About page" do
    before {visit about_path}
    it_should_behave_like 'all static pages'
  end

  describe "Contact Page" do
    before {visit contact_path}
  	it_should_behave_like 'all static pages'
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', :text=>"#{base_title} #{@action}"
  end
end