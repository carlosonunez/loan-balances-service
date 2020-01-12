# frozen_string_literal: true

require 'spec_helper'

describe 'Given a provider' do
  context 'When we add new credentials to our credentials store' do
    example 'Then they get added', :unit_with_database do
      SpecHelpers::Aws::DynamoDBLocal.drop_tables!
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
end
