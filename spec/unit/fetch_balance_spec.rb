# frozen_string_literal: true

describe 'Given a loan from a loan provider' do
  context 'When I fetch a balance from it' do
    context 'And a password does not exist for the username provided' do
      example 'Then we do not get a balance', :unit do
        expect(LoanBalancesService::Subservice)
          .to receive(:find)
          .and_return('Foo')
        expect do
          LoanBalancesService.fetch_balance(provider: 'foo',
                                            username: 'bar')
        end
          .to raise_error('No password exists for this username and provider.')
      end
    end
  end
end
