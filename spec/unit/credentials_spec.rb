# frozen_string_literal: true

require 'ostruct'
require 'spec_helper'

describe 'Given a provider' do
  context 'When we add new credentials to our credentials store' do
    example 'Then they get added', :unit_with_database do
      expect do
        LoanBalancesService::Credentials.save!(provider: 'foo',
                                               username: 'bar',
                                               password: 'baz')
      end
        .not_to raise_error

      dynamodb = ::Aws::DynamoDB::Client.new
      response = dynamodb.get_item(
        table_name: 'provider-data-test_credentials',
        key: { provider: 'foo' }
      )
      expect(response.item['provider']).to eq 'foo'
      expect(response.item['username']).to eq 'bar'
      actual_pw = BCrypt::Password.new(response.item['password'])
      expect(actual_pw).to eq 'baz'
    end
  end

  context 'When we fetch credentials' do
    example 'Then we get them', :unit do
      fake_credential_result = [OpenStruct.new(
        provider: 'foo',
        username: 'bar',
        password: 'fake-hashed-password'
      )]
      allow(LoanBalancesService::Credential).to receive(:where)
        .and_return(fake_credential_result)
      expect(BCrypt::Password)
        .to receive(:create)
        .and_return('baz')
      expect(LoanBalancesService::Credentials.get(provider: 'foo',
                                                  username: 'baz'))
        .to eq('baz')
    end
  end
end
