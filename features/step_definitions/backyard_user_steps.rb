When /^I store the following users in the backyard:$/ do |users_table|
  users_table.hashes.each do |row|
    attributes = {}
    put_model(:user, row['Name'], attributes)
  end
end

Then /^the user "([^"]*)" should have the (username|email) "([^"]*)"$/ do |user_name, attribute, value|
  user = get_model(:user, user_name)
  user.send(attribute).should == value
end
