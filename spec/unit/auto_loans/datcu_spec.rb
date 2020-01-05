# frozen_string_literal: true

require 'spec_helper'

describe 'Given a DATCU auto loan' do
  context 'When I retrieve its balance' do
    example 'Then I am able to retrieve it', :wip do
      expect(LoanBalancesService.get_balance(provider: 'datcu')).to eq '$50,000'
    end
  end
end
