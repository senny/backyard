def backyard_model
  '(user)s?'
end

Given /^I use the factory_girl adapter for backyard$/ do
  require 'factory_girl'
  Factory.find_definitions
  Backyard.config.use_adapter :factory_girl
end

When /^I store the following #{backyard_model} in the backyard:$/ do |model_type, model_table|
  model_table.hashes.each do |row|
    attributes = {}
    put_model(model_type, row['Name'], attributes)
  end
end

When /^I store the #{backyard_model} "([^"]*)" in the backyard$/ do |model_type, model_name|
  put_model(model_type, model_name)
end

Then /^the backyard should have (\d+) stored #{backyard_model}$/ do |amount, model_type|
  models(model_type).should have(amount.to_i).item
end

Then /^the backyard should have a stored #{backyard_model} named "([^"]*)"$/ do |model_type, model_name|
  get_model(model_type, model_name).should_not be_nil
end
