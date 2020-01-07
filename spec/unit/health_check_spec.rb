# frozen_string_literal: true

describe 'Given the loan balances service' do
  context 'When I run health checks' do
    example 'Then it pings', :unit do
      expect(LoanBalancesService::HealthCheck.ping)
        .to eq "Hello from Carlos's Loan Balance service!"
    end
  end
end
