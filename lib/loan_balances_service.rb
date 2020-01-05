# frozen_string_literal: true

Dir.glob('lib/loan_balances_service/**/*.rb').each do |file|
  module_name = file.sub(%r{^lib/(.*).rb$}, '\1')
  puts "Requiring #{module_name}"
  require module_name
end

module LoanBalancesService
  def self.fetch_balance(provider:)
    sub_service = Subservice.find(provider)
    raise "Provider not found: #{sub_service}" if sub_service.nil?

    Object.const_get("LoanBalancesService::Providers::#{sub_service}").balance
  end
end
