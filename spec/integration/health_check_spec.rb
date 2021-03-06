# frozen_string_literal: true

describe 'Given a live Loan Balances service' do
  context 'When I ping it' do
    example 'Then it responds', :integration do
      SpecHelpers::Service.get('/ping') do |response|
        expect(response.code).to eq 200
        expect(response.body).to eq({
          status: 'ok',
          message: "Hello from Carlos's Loan Balance service!"
        }.to_json)
      end
    end
  end
end
