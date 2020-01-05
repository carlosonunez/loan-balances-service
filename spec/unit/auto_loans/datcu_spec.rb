# frozen_string_literal: true

require 'spec_helper'

describe 'Given a DATCU auto loan' do
  context 'When I retrieve its balance' do
    before(:each) { TestMocks.generate! }

    example 'Then I am able to retrieve it', :unit do
      expect(LoanBalancesService.fetch_balance(provider: 'datcu'))
        .to eq '$50,000'
    end
  end
end
