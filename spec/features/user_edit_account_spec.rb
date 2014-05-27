require 'spec_helper'

feature "User edits account" do
  scenario "happy path" do
    User.create(email: "joe@example.com", password: "mypassword")
    visit '/'
    click_link "Sign in"
    fill_in "Email", with: "joe@example.com"
    fill_in "Password", with: "mypassword"
    click_button "Sign in"
    visit '/users/edit'
    fill_in "Email", with: "elvis@example.com"
    fill_in "Password", with: "newpassword"
    fill_in "Password confirmation", with: "newpassword"
    fill_in "Current password", with: "mypassword"
    click_button "Update"
    page.should have_content "You updated your account successfully."

    page.should_not have_link("Update")
  end

  scenario "user enters wrong password confirmation" do
    User.create(email: "joe@example.com", password: "mypassword")
    visit '/'
    click_link "Sign in"
    fill_in "Email", with: "joe@example.com"
    fill_in "Password", with: "mypassword"
    click_button "Sign in"
    visit '/users/edit'
    fill_in "Email", with: "elvis@example.com"
    fill_in "Password", with: "newpassword"
    fill_in "Password confirmation", with: "notnewpassword"
    fill_in "Current password", with: "mypassword"
    click_button "Update"
    page.should have_content "Please review the problems below:"

    page.should have_error("doesn't match Password", on: "Password confirmation")
  end

  scenario "user enters wrong current password" do
    User.create(email: "joe@example.com", password: "mypassword")
    visit '/'
    click_link "Sign in"
    fill_in "Email", with: "joe@example.com"
    fill_in "Password", with: "mypassword"
    click_button "Sign in"
    visit '/users/edit'
    fill_in "Email", with: "elvis@example.com"
    fill_in "Password", with: "newpassword"
    fill_in "Password confirmation", with: "newpassword"
    fill_in "Current password", with: "notmypassword"
    click_button "Update"
    page.should have_content "Please review the problems below:"

    page.should have_error("is invalid", on: "Current password")
  end

  scenario "user leaves email blank" do
    User.create(email: "joe@example.com", password: "mypassword")
    visit '/'
    click_link "Sign in"
    fill_in "Email", with: "joe@example.com"
    fill_in "Password", with: "mypassword"
    click_button "Sign in"
    visit '/users/edit'
    fill_in "Email", with: ""
    fill_in "Password", with: "newpassword"
    fill_in "Password confirmation", with: "newpassword"
    fill_in "Current password", with: "mypassword"
    click_button "Update"
    page.should have_content "Please review the problems below:"

    page.should have_error("can't be blank", on: "Email")
  end
end
