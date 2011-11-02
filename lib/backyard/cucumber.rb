require 'backyard'

World(Backyard::Session)

Before '@name_based_database_lookup' do
  Backyard.name_based_database_lookup = true
end

After do
  Backyard.reset_name_based_database_lookup
end
