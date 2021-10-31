require "application_system_test_case"

class LoginsTest < ApplicationSystemTestCase
  setup do
    @u1 = users(:u1)
    @u2 = users(:u2)
  end

  test "u1 login success" do
    visit main_url
    fill_in "Email", with: @u1.email
    fill_in "Password", with: 'a'
    click_on "Login"
    assert_text "User was successfully login."
  end

  test "u2 login success" do
    visit main_url
    fill_in "Email", with: @u2.email
    fill_in "Password", with: 'b'
    click_on "Login"
    assert_text "User was successfully login."
  end

  test "u1 login failed" do
    visit main_url
    fill_in "Email", with: @u1.email
    fill_in "Password", with: '12345678'
    click_on "Login"
    assert_text "Your email or password is invalid."
  end

  test "u1 login but not enter password" do
    visit main_url
    fill_in "Email", with: @u1.email
    click_on "Login"
    assert_text "Your email or password is invalid."
  end

  test "u1 login but not enter email" do
    visit main_url
    fill_in "Password", with: '123456'
    click_on "Login"
    assert_text "Your email or password is invalid."
  end

  test "login but not enter anything" do
    visit main_url
    click_on "Login"
    assert_text "Your email or password is invalid."
  end

end