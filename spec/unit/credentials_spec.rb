# frozen_string_literal: true

require 'spec_helper'

describe 'Given a provider' do
  context 'When we add new credentials to our credentials store' do
    example 'Then they get added', :unit_with_database do
      SpecHelpers::Aws::DynamoDBLocal.drop_tables!

      expect(SecureRandom).to receive(:hex)
        .exactly(1).times
        .and_return('random_salt')
      expect(LoanBalancesService::Credentials.save(provider: 'foo',
                                                   username: 'bar',
                                                   password: 'baz',
                                                   more_stuff: 'quux'))
        .not_to raise_error

      dynamodb = ::Aws::DynamoDB::Client.new
      hashed_password =
        '$2a$12$caPFayRVuSbBDw0v6RDFtebXhq/S4CE0gti36xQDWwxAP.DdLmujq'
      response = dynamodb.get_item(
        table_name: 'loan-balances-service_provider_data_test_credentials',
        key: { "Provider": { s: 'foo' } }
      )
      expect(response.item).to eq(
        "Provider": { s: 'foo' },
        "Username": { s: 'bar' },
        "Password": { s: hashed_password }
      )
    end
  end
end
