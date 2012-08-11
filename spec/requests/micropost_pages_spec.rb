require 'spec_helper'

describe "Micropost Pages" do
 	subject { page }
 	let(:user) { FactoryGirl.create(:user) }
 	before { login_user(user) }
 	describe "micropost creation" do
 		before { visit root_path }
 		describe "with invalid inforation" do
 			it "should not change micropost count" do
 				expect { click_button "Post" }.should_not change(Micropost, :count)
 			end
 			describe "error message" do
 				before { click_button "Post" }
 				it { should have_content('Error') }
 			end
 		end
 		describe "with valid information" do
 			before { valid_micropost }
 			it "should create a micropost" do
 				expect { click_button "Post" }.should change(Micropost, :count).by(1)
 			end
 		end
 	end
end
