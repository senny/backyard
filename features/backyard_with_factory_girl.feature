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
