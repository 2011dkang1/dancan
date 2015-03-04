require "dancan/version"
require "dancan/policy_finder"
require "active_support/concern"
require "active_support/core_ext/string/inflections"
require "active_support/core_ext/object/blank"
require "active_support/core_ext/module/introspection"
require "active_support/dependencies/autoload"

module Dancan
  class NotAuthorizedError < StandardError
    attr_accessor :roles, :record, :policy
  end
  class AuthorizationNotPerformedError < StandardError; end
  class PolicyScopingNotPerformedError < AuthorizationNotPerformedError; end
  class NotDefinedError < StandardError; end

  extend ActiveSupport::Concern

  class << self

    def policy(user, record)
      policy = PolicyFinder.new(record).policy
      policy.new(user, record) if policy
    end

    def policy!(user, record)
      PolicyFinder.new(record).policy!.new(user, record)
    end
  end

  included do
    if respond_to?(:helper_method)
      helper_method :policy
      helper_method :dancan_admin
    end
    if respond_to?(:hide_action)
      hide_action :policy
      hide_action :policies
      hide_action :restrict_access
      hide_action :dancan_admin
    end
  end

  def restrict_access(record, permitted_roles=nil)
    
    
    roles = permitted_roles
    policy = policy(record)
    unless roles.map().any? { |role| policy.public_send(role) }
      error = NotAuthorizedError.new("#{record} does not have not roles: #{roles.to_s}")
      error.roles, error.record, error.policy = roles.to_s, record, policy

      raise error
    end

    true
  end

  def policy(record)
    policies[record] ||= Dancan.policy!(dancan_admin, record)
  end

  def policies
    @_dancan_policies ||= {}
  end

  def dancan_admin
    current_admin
  end

end



