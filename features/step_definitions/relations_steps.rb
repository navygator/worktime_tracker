Given /^a user sign in as admin$/ do
  @admin = FactoryGirl.create(:admin)
  @user = FactoryGirl.create(:user)
  visit signin_path
  fill_in "Email", with: @admin.email
  fill_in "Password", with: @admin.password
  click_button "Sign in"
end

When /^he visit relations page$/ do
  visit relations_path
end

And /^he click (.*) link$/ do |link|
  link = "approver_#{@admin.id}" if link == "User"
  click_link "#{link}"
end

Then /^he should see add user dialog$/ do
  page.should have_selector("select")
end

When /^he select a user from list$/ do
  select(@user.short_name)
end

And /^he click ok button$/ do
  click_button "Ok"
end

Then /^he should see user at approved table$/ do
  page.should have_selector("td", text: @user.short_name)
end

Then /^he should see Approvers$/ do
  page.should have_selector("ul#approvers")
end
