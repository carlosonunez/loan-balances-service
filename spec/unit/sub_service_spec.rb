# frozen_string_literal: true

require 'spec_helper'

describe 'Given a provider name' do
  context 'When I find it in our list of providers' do
    example "Then it finds the 'sub-service' corresponding to it", :unit do
      mocked_providers = <<~PROVIDERS
        ---
        foo: Foo
      PROVIDERS
      allow(File).to receive(:read)
        .with('include/providers.yml')
        .and_return(mocked_providers)
      expect(LoanBalancesService::Subservice.find('foo')).to eq 'Foo'
    end
  end
end
