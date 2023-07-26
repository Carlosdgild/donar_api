# frozen_string_literal: true

#
# Main Application Service class wrapper
# Services should perform some kind of error handling and return the data (if any) with the boolean indicating if an error occurred
# Services should use Forms, if needed
#
class ApplicationService
  #
  # Wrapper for new services to call directly perform
  #
  def self.perform(...)
    new(...).perform
  end

  #
  # Pundit authorize action wrapper
  #
  # @param [User] current_user - The current user executing the action
  # @param [Object] record - The object we're checking permissions of
  # @param [Symbol, String] action - The predicate method to check on the policy (e.g. :show?)
  # @param [Class] policy_class - The policy class we want to force use of
  #
  # @return [Object] Always returns the passed object record
  #
  # :reek:UtilityFunction
  def authorize(current_user, record, action, policy_class: nil)
    Pundit.authorize(current_user, record, action, policy_class: policy_class)
  end

  #
  # Pundit policy scope action wrapper
  #
  # @param [User] current_user - The current user executing the action
  # @param [Object] scope - The object we're retrieving the policy scope for
  #
  # @return [Scope{#resolve}, nil] Instance of scope class which can resolve to a scope
  #
  # :reek:UtilityFunction
  def policy_scope(current_user, scope)
    Pundit.policy_scope(current_user, scope)
  end
end
