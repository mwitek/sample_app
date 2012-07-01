# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#
require 'spec_helper'

describe User do
	before do
    @user = User.new(:name => "Example User", :email => "user@example.com", 
                     :password => "foobar", :password_confirmation => "foobar")
  	end

	subject {@user}

	it {should respond_to :name}
	it {should respond_to :email}
	it {should respond_to :password_digest}
	it {should respond_to :password}
	it {should respond_to :password_confirmation}
	it {should be_valid}
	it {should respond_to :authenticate}
	
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
			addresses = %w(user@foo,com user_at_foo.org example.user@foo.
	                     foo@bar_baz.com foo@bar+baz.com)
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
end
