# frozen_string_literal: true

Dir.glob('lib/loan_balances_service/**/*.rb').each do |file|
  require file.sub(%r{^lib/(.*).rb$}, '\1')
end

module LoanBalancesService
  def self.get_balance(provider:)
    sub_service = Subservice.find(provider)
    raise "Provider not found: #{sub_service}" if sub_service.nil?

    public_send("LoanBalancesService::Providers::#{sub_service}.balance")
  end
end
