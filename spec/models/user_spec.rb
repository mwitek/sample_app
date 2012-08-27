# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean         default(FALSE)
#

require 'spec_helper'

describe User do
	before do
    @user = User.new(:name => "Example User",:email => "user@example.com",:password => "foobar", :password_confirmation => "foobar")
  end

	subject {@user}
	it { should be_valid }
	it { should respond_to :name }
	it { should respond_to :email }
	it { should respond_to :password_digest }
	it { should respond_to :password }
	it { should respond_to :password_confirmation }
	it { should respond_to :remember_token }
	it { should respond_to :authenticate }
	it { should respond_to :microposts }
	it { should respond_to :feed  }
	it { should respond_to :relationships }
	it { should respond_to :followed_users }
	it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
	it { should respond_to :following? }
	it { should respond_to :follow! }
	it { should respond_to :unfollow! }

	describe "following a user" do
		let(:other_user) { FactoryGirl.create(:user) }
		before do
			@user.save
			@user.follow!(other_user)
		end
		it { should be_following(other_user) }
		its(:followed_users) { should include(other_user) }
		describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end
		describe "unfollowing" do
			before { @user.unfollow!(other_user) }
			it { should_not be_following(other_user) }
			its(:followed_users) { should_not include(other_user) }
		end
	end
	
	describe "When name is not valid" do
		before { @user.name = "a"*51 }
		it { should_not be_valid }
	end

	describe "When Email is not valid" do
		before {@user.email = ""}
		it {should_not be_valid}
	end

	describe "When Email format is not valid" do
		it "should not be valid" do
			addresses = %w(user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com)
			addresses.each do |invalid_email|
				@user.email = invalid_email
				@user.should_not be_valid

			end
		end
	end

	describe "When email format is valid" do
		it "should be valid" do
			addresses = %w(user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn)
			addresses.each do |valid_email|
				@user.email = valid_email
				@user.should be_valid
			end
		end
	end

	describe "When Email is already taken" do
		before do
			dup_email = @user.dup
			dup_email.email = dup_email.email.upcase
			dup_email.save
		end
		it {should_not be_valid}
	end

	describe "Return Value of Authenticate method" do
		
		before { @user.save }
	  let(:found_user) { User.find_by_email(@user.email) }
		
		describe "User with valid password" do
			it {should == found_user.authenticate(@user.password)}
		end
		
		describe "User with invalid password" do
			let(:user_with_invalid_password) {found_user.authenticate('invalid')}
			it {should_not == user_with_invalid_password}
			specify {user_with_invalid_password.should be_false}
		end
		
		describe "a user password that is too short" do
			before {@user.password = "a"*5}
			
			it {should_not be_valid}
		end
	end
	
	describe "email address with mixed case" do
		let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

	    it "should be saved as all lower-case" do
			@user.email = mixed_case_email
			@user.save
			@user.reload.email.should == mixed_case_email.downcase
	    end
	end

	describe "at user token" do
		before {@user.save}
		its(:remember_token) {should_not be_blank}
	end

	describe "micropost associations" do

    before { @user.save }
    let!(:older_micropost) do 
      FactoryGirl.create(:micropost, :user => @user, :created_at => 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [newer_micropost, older_micropost]
    end

    it "should destroy associated micropost" do
    	microposts = @user.microposts
    	@user.destroy
    	microposts.each do |post|
    		Micropost.find_by_id(post.id).should be_nil
    	end
    end
  	describe "Status" do
  		let(:unfollow) { FactoryGirl.create(:micropost, :user => FactoryGirl.create(:user)) }
  	end
  end
end