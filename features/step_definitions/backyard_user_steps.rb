When /^I store the following users in the backyard:$/ do |users_table|
  users_table.hashes.each do |row|
    attributes = {}
    put_model(:user, row['Name'], attributes)
  end
end
