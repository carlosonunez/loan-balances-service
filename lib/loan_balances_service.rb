# frozen_string_literal: true

require 'loan_balances_service/aws_helpers/api_gateway'

Dir.glob('lib/loan_balances_service/**/*.rb').each do |file|
  module_name = file.sub(%r{^lib/(.*).rb$}, '\1')
  puts "Requiring #{module_name}"
  require module_name
end

module LoanBalancesService
  @logger = Logger.new(STDOUT)
  @logger.level = ENV['LOG_LEVEL'] || Logger::WARN
  def self.logger
    @logger
  end

  def self.ping
    AWSHelpers::APIGateway.ok(
      message: "Hello from Carlos's Loan Balance service!"
    )
  end

  def self.fetch_balance(provider:, **args)
    sub_service = Subservice.find(provider)
    raise "Provider not found: #{sub_service}" if sub_service.nil?

    browser = Browser.new
    Object.const_get("LoanBalancesService::Providers::#{sub_service}")
          .balance(browser, args)
  end
end
