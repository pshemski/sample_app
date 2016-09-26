require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
  	@user = User.new(name: "Example User", email: "user@example.com",
  									 password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
  	assert @user.valid?
  end

  test "name should be present" do
  	@user.name = " "
  	assert_not @user.valid?
  end

  test "email should be present" do
  	@user.email = " "
  	assert_not @user.valid?
  end

  test "name should not be too long" do
  	@user.name = "a" * 65
  	assert_not @user.valid?
  end

  test "email should not be too long" do
  	@user.email = "a" * 129
  	assert_not @user.valid?
  end

  test "email validation should accept valid address" do
  	valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.com 
	 								 			 first.last@foo.jp alice+bob@baz.cn]
  	valid_addresses.each do |valid_address|
  		@user.email = valid_address
  		assert @user.valid?, "#{valid_address.inspect} should be valid"
  	end
  end

  test "email validation should reject invalid addresses" do
  	invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
    	@user.email = invalid_address
    	assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email address should be unique" do
  	duplicate_user = @user.dup
  	duplicate_user.email = @user.email.upcase
  	@user.save
  	assert_not duplicate_user.valid?
  end

  test "email address should be saved as lower-case" do
  	mixed_case_email = "Foo@Bar.CoM"
  	@user.email = mixed_case_email
  	@user.save
  	assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
  	@user.password = @user.password_confirmation = " " * 6
  	assert_not @user.valid?
  end

  test "password should have a minimum length" do
  	@user.password = @user.password_confirmation = "a" * 5
  	assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated micropost should be destroyed" do
    @user.save
    @user.microposts.create!(content: "haha")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test " should follow and unfollow a user" do
    michael = users(:michael)
    archer = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followed?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

  test "feed should have the right post" do
    michael = users(:michael)
    archer = users(:archer)
    lana = users(:lana)
    # followed user posts
    lana.microposts.each do |following_post|
      assert michael.feed.include?(following_post)
    end
    # self posts
    michael.microposts.each do |self_post|
      assert michael.feed.include?(self_post)
    end
    #unfollowed posts
    archer.microposts.each do |unfollowed_post|
      assert_not michael.feed.include?(unfollowed_post)
    end
  end
end















