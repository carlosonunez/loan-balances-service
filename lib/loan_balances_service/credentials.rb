# frozen_string_literal: true

require 'bcrypt'
require 'dynamoid'
require 'logger'

module LoanBalancesService
  class Credential
    Dynamoid.configure do |config|
      config.namespace = "provider-data-#{ENV['ENVIRONMENT']}"
      config.logger.level = Logger::FATAL
    end

    include Dynamoid::Document
    table name: :credentials,
          key: :provider,
          read_capacity: 2,
          write_capacity: 2
    field :provider
    field :username
    field :password
  end

  module Credentials
    def self.save!(provider:, username:, password:)
      credential = Credential.new(provider: provider,
                                  username: username,
                                  password: hash_password(password))
      credential.save
    end

    def self.get(provider:, username:)
      found_credentials = Credential.where(provider: provider,
                                           username: username)
      return nil if found_credentials.count.zero?

      credential = found_credentials.first
      BCrypt::Password.create(credential.password)
    end

    def self.hash_password(password)
      BCrypt::Password.create(password)
    end

    private_class_method :hash_password
  end
end
