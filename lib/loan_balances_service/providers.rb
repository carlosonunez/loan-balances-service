# frozen_string_literal: true

require 'loan_balances_service/browser'
require 'loan_balances_service/credentials'
require 'loan_balances_service/sub_service'

Dir.glob('lib/loan_balances_service/providers/*.rb').each do |file|
  module_name = file.sub(%r{^lib/(.*).rb$}, '\1')
  require module_name
end

module LoanBalancesService
  class Provider
    attr_reader :credentials, :name

    def initialize(provider_name, username, **args)
      @browser = LoanBalancesService::Browser.new
      @name = provider_name
      @sub_service = LoanBalancesService::Subservice.find(provider_name)
      @password = LoanBalancesService::Credentials.get(provider: provider_name,
                                                       username: username)
      @additional_args = args
    end

    def password?
      !@password.nil?
    end

    def service?
      !@sub_service.nil?
    end

    def balance
      Object.const_get("LoanBalancesService::Providers::#{@sub_service}")
            .balance(@browser,
                     @additional_args,
                     username: @username,
                     password: @password)
    end
  end
end
