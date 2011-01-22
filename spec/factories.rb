Factory.define :string do |f| end
Factory.define :array do |f| end
Factory.define :hash do |f| end
Factory.define :my_string_factory, :class => 'String' do |f| end
Factory.define :my_hash_factory, :class => Hash do |f| end

require File.join(File.dirname(__FILE__), 'models')

Factory.define :user do |f|
  f.username 'John Doe'
end
