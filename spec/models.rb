require 'active_record'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3",
                                        :database  => ":memory:")
orig_stdout = $stdout
$stdout = File.new('/dev/null', 'w')
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :username
  end

  create_table :accounts do |t|
    t.string :description
    t.integer :owner_id
  end
end
$stdout = orig_stdout

require File.join(File.dirname(__FILE__), 'models', 'user')
require File.join(File.dirname(__FILE__), 'models', 'account')
