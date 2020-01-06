# frozen_string_literal: true

require 'spec_helper'

describe 'Given a DATCU auto loan' do
  context 'When I retrieve its balance' do
    example 'Then I am able to retrieve it', :unit do
      test_acct_num = 'ABCD12345-A06'
      TestMocks.generate_mock_session!('https://online.datcu.org')
      expect(LoanBalancesService.fetch_balance(provider: 'datcu',
                                               account_number: test_acct_num,
                                               username: 'example_user',
                                               password: 'example_password',
                                               challenge_answer: 'foo'))
        .to eq 50_000.00
    end
  end
end
