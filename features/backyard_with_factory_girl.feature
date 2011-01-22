Feature: backyard should work with FactoryGirl

  Background:
    Given I use the factory_girl adapter for backyard

  Scenario: store and retrieve an object
    When I store the user "John" in the backyard
    Then the backyard should have 1 stored users
    And the backyard should have a stored user named "John"

  Scenario: store multiple objects
    When I store the following users in the backyard:
      | Name   |
      | John   |
      | Jane   |
      | Jackob |
    Then the backyard should have 3 stored users
    And the backyard should have a stored user named "John"
    And the backyard should have a stored user named "Jane"
    And the backyard should have a stored user named "Jackob"

  Scenario: store associated models
    When I store the following accounts in the backyard:
      | Description    | Owner |
      | Taxes          | John  |
      | John's Savings | John  |
      | Jane's Savings | Jane  |
    Then the backyard should have 2 stored users
    And the backyard should have 3 stored accounts
    And the account "Taxes" should be owned by "John"
    And the account "John's Savings" should be owned by "John"
    And the account "Jane's Savings" should be owned by "Jane"

  Scenario: use the backyard name as model attribute
    Given I have the following backyard configuration:
    """
    Backyard.configure do
      name_attribute :description, :for => :account
    end
    """
    When I store the account "Holidays" in the backyard
    Then the account "Holidays" should have the description "Holidays"

  Scenario: advanced configuration for model names
    Given I have the following backyard configuration:
    """
    Backyard.configure do
      name_for :user do |name|
        {:username => name,
        :email => "#{name.downcase.gsub(/\s/, '.')}@gmail.com"}
      end
    end
    """
    When I store the user "John Doe" in the backyard
    Then the user "John Doe" should have the username "John Doe"
    And the user "John Doe" should have the email "john.doe@gmail.com"
