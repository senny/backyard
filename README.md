# Backyard

this project is in a 'work in progress' state. The object creation currently only works with factory_girl.

## Installation

in your Gemfile:

    gem 'backyard'

in your features/support/env.rb:

    require 'backyard/cucumber'

to configure backyard, you need to create a backyard.rb file in your features/support directory:

    Backyard.configure do
      name_attribute :username, :for => :user
      name_attribute :title, :for => [:post, :comment]
    end

## Usage

Backyard provides a simple dsl to name the models in your cucumber scenarios.

    put_model(:post, 'How to use Backyard') # create and store a new Post model named 'How to use Backyard'
    put_model(:post, 'I am published', {:published => true}) # you can pass additional options for the factory

    my_comment = Comment.first
    put_instance(my_comment, 'My Comment') # you can also store existing models

Backyard keeps track of your saved models and you can access them from all the step definitions:

    get_model(:post, 'How to use Backyard') # returns the stored post instance

If you want to write step definitions, which do not care if the model you are referencing exists then you can use the `model´ method. It will check if the model with the given name exists and if not, it will create a new model for you.

    model(:user, 'Tester') # this will return the user called 'Tester' if one has been crated, otherwise it will create a new model for you
    model(:user, 'Gardener', {:approved => true})  # you can also pass additional attributes for the factories

## Configuration

Backyard needs to know how to name your models correctly. You can define the rules using the `Backyard.configure` method:

    Backyard.configure do
      name_attribute :title, :for => :article
    end

    # Examples
    put_model(:article, 'Getting Started with Rails') # this creates an Article instance with the titel: 'Getting Started with Rails'
    model(:article, 'Getting Started with Rails') # returns the article created above
    model(:article, 'Upgrading to Rails 3') # since no article with the given name has been created it will create one.

There are situations when the name of your model is not as simple as setting an attribute. In these circumstances you can register a block to set the name of your model accordingly:

    Backyard.configure do
      name_for :owner do |name|
        { :user => model(:user, name, {:username => name}) }
      end
    end

If all users in your system are named with the username attribute you could use the following configuration:

    Backyard.configure do
      name_attribute :username, :for => :user

      name_for :owner do |name|
        { :user => model(:user, name) }
      end
    end

    # Examples
    put_model(:user, 'John') # creates a User with username: 'John'
    put_model(:owner, 'Jane') # creates a Owner with an associated User, which has the username: 'Jane'

This will still create Owner models with an associated user, where the username is set to the name of the created Owner model. This configuration has the advantage, that the username is also beeing set if you just create a User model.

## Community

### Got a question?

Just send me a message and I'll try to get to you as soon as possible.

### Found a bug?

Please register a new issue.

### Fixed something?

1. Fork backyard
2. Create a topic branch - `git checkout -b my_branch`
3. Make your changes and update the History.txt file
4. Push to your branch - `git push origin my_branch`
5. Send me a pull-request for your topic branch
6. That's it!
