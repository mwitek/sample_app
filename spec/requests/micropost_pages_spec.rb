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
 				it { should have_content('error') }
 			end
 		end
 		describe "shoud break words that are to long" do
 		end
 		describe "with valid information" do
 			before { valid_micropost }
 			it "should create a micropost" do
 				expect { click_button "Post" }.should change(Micropost, :count).by(1)
 			end
 		end
 		describe "Micropost distruction" do
 			before do
 				FactoryGirl.create(:micropost, :user => user, :content => "lorem, Ipsum")
 				visit root_path
 			end	
 			it "should delete micropost" do
 				expect { click_link "delete"}.should change(Micropost, :count).by(-1)
 			end
 		end
 	end
end
