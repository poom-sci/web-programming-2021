require "application_system_test_case"

class LikeOnFeedsTest < ApplicationSystemTestCase
  setup do
    @testlikeuser1 = users(:testlikeuser1)
    @testlikeuser2 = users(:testlikeuser2)
    @post = posts(:post1)
  end

  test "user2 like user1 post" do
    #login with testlikeuser2
    visit main_url
    fill_in "Email", with: @testlikeuser2.email
    fill_in "Password", with: 'testliketwo'
    click_on "Login"

    #go to testlikeuser1 profile and follow
    visit profile_path(name: @testlikeuser1.name)
    click_on "Follow"

    #go to feed and like testlikeuser1 post
    click_on "MiniTwitter"
    click_on "Like", match: :first

    #check testlikeuser1 profile that shown one like
    click_on @testlikeuser1.name
    assert_text "1 likes"
    assert_text @testlikeuser1.name
  end
end