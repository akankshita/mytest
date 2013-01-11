def create_user(username = "jackson", password = "jackson", email = "jackson@jackson.com")
  user = User.create(:username => username, :password => password, :password_confirmation => password, :email => email)
  assert_saved(user)

  return user
end