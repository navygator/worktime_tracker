Given /^a admin visit relations page$/ do
  @admin = FactoryGirl.create(:admin)
  @user = FactoryGirl.create(:user)
  visit signin_path
  fill_in "Email", with: @admin.email
  fill_in "Password", with: @admin.password
  click_button "Sign in"
  visit relations_path
end

When /^he click add link$/ do
  click_link "Add"
end

Then /^he should see add user dialog$/ do
  page.should have_selector("select")
end

When /^he select a user from list$/ do
  select(@user.last_name)
end

And /^he click ok button$/ do
  click_button "Ok"
end

Then /^he should see user at approved table$/ do
  page.should have_selector("td", text: @user.short_name)
end