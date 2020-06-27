require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test "Setting password will generate correct hash and salt" do
    u = User.new({name: "Shlomi", email:"shlomi@email.com"})
    u.password = "1234"

    assert_not_nil u.password_hash
    assert_not_nil u.salt
  end

  test "Check Password should work when correct password is given" do 
    u = User.new({name: "Shlomi", email:"shlomi@email.com"})
    u.password = "1234"

    assert u.check_password "1234"
  end

  test "Check Password should fail when incorrect password is given" do
    u = User.new({name: "Shlomi", email:"shlomi@email.com"})
    u.password = "1234"

    assert_not u.check_password "5678"
  end


  test "User password_hash and salt are not saveable" do
    u = User.new({name: "Shlomi", email:"shlomi@email.com"})
    u.password = "1234"
    old_hash = u.password_hash
    old_salt = u.salt
    
    assert_equal old_hash, u.password_hash
    assert_equal old_salt, u.salt
  end
end
