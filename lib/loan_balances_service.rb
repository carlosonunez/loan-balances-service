# frozen_string_literal: true

require 'logger'
require 'loan_balances_service/health_check'
require 'loan_balances_service/providers'

module LoanBalancesService
  @logger = Logger.new(STDOUT)
  @logger.level = ENV['LOG_LEVEL'] || Logger::WARN
  def self.logger
    @logger
  end

  def self.fetch_balance(provider:, username:, **args)
    provider = Provider.new(provider, username, args)
    unless provider.password?
      raise 'No password exists for this username and provider.'
    end

    provider.balance
  end
end
