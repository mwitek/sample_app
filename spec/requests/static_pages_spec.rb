require 'spec_helper'
describe "Static pages" do
  
  subject {page}
  let(:user) { FactoryGirl.create :user }
  shared_examples_for 'all static pages' do
    it {should have_selector('title', :text=>"#{base_title} #{@action}")}
    it "should have the right links on the layout" do
      click_link "About"
      click_link "Help"
      click_link "Home"
      click_link "sample app"
      page.should have_selector 'title', :text=>"#{base_title} #{@action}"
    end 
  end

  let(:base_title){ "Ruby on Rails Tutorial Sample App |"}
 
  describe "Home page" do
    before {visit root_path}
    it {should have_selector('h1', :text => "Welcome to the Sample App")}
    it_should_behave_like 'all static pages'

    describe "for signed in users" do
      before do
        login_user(user)
        FactoryGirl.create(:micropost, :user => user, :content => "lorem ipsum")
        FactoryGirl.create(:micropost, :user => user, :content => "ipsum ipsum")
        visit root_path
      end
      it { should have_selector('h1', :text => user.name) }
      it "should render the users feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", :text => item.content)
        end
      end
    end
  end

  describe "Help page" do
    before {visit help_path}
    it {should have_selector('h1', :text => 'Help Page')}
    it_should_behave_like 'all static pages'
  end
  
  describe "About page" do
    before {visit about_path}
    it {should have_selector('h1', :text => 'About Page')}
    it_should_behave_like 'all static pages'
  end

  describe "Contact Page" do
    before {visit contact_path}
    it {should have_selector('h1', :text => 'Contact Page')}
  	it_should_behave_like 'all static pages'
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', :text=>"#{base_title} #{@action}"
  end
end