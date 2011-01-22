require 'active_record'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3",
                                        :database  => ":memory:")
orig_stdout = $stdout
$stdout = File.new('/dev/null', 'w')
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :username, :null => false
  end
end
$stdout = orig_stdout

require File.join(File.dirname(__FILE__), 'models', 'user')
