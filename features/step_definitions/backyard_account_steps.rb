When /I store the following accounts in the backyard:/ do |accounts_table|
  accounts_table.hashes.each do |row|
    attributes = {}

    if row['Owner'].present?
      model(:user, row['Owner'])
      attributes[:owner] = model(:user, row['Owner'])
    end

    put_model(:account, row['Description'], attributes)
  end
end

Then /^the account "([^"]*)" should be owned by "([^"]*)"$/ do |account_name, owner_name|
  get_model(:account, account_name).owner.should == get_model(:user, owner_name)
end

Then /^the account "([^"]*)" should have the description "([^"]*)"$/ do |account_name, description|
  get_model(:account, account_name).description.should == description
end
