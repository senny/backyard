Feature: backyard should work with FactoryGirl

  Background:
    Given I use the factory_girl adapter for backyard

  Scenario: store ant retrieve an object
    When I store the user "John" in the backyard
    Then the backyard should have 1 stored users
    And the backyard should have a stored user named "John"
