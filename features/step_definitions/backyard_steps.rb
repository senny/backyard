def backyard_model
  '(user|account)s?'
end

Given /^I use the factory_girl adapter for backyard$/ do
  require 'factory_girl'
  Backyard.config.use_adapter :factory_girl
  Backyard.config.adapter_instance.class.factory_girl_class.find_definitions
end

Given /^I have the following backyard configuration:$/ do |string|
  eval(string)
end

When /^I store the #{backyard_model} "([^"]*)" in the backyard$/ do |model_type, model_name|
  put_model(model_type, model_name)
end

Then /^the backyard should have (\d+) stored #{backyard_model}$/ do |amount, model_type|
  get_models(model_type).should have(amount.to_i).item
end

Then /^the backyard should have a stored #{backyard_model} named "([^"]*)"$/ do |model_type, model_name|
  get_model(model_type, model_name).should_not be_nil
end
