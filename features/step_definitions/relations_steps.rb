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

And /^he click (.*) button$/ do |button|
  click_button "#{button}"
end

And /^he accept alert$/ do
  alert = page.driver.browser.switch_to.alert
  alert.accept
end

Then /^he should see user at approved table$/ do
  page.should have_selector("td", text: @user.short_name)
end

Then /^he should not see user at approved table$/ do
  page.should_not have_selector("td", text: @user.short_name)
end
