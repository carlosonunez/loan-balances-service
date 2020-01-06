# frozen_string_literal: true

describe 'Given the loan balances service' do
  context 'When I ping it' do
    example 'Then it responds back', :unit do
      expect(LoanBalancesService.ping).to eq(
        statusCode: 200,
        body: {
          status: 'ok',
          message: "Hello from Carlos's Loan Balance service!"
        }.to_json
      )
    end
  end
end
