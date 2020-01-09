#!/usr/bin/env ruby
$LOAD_PATH.unshift('./lib')
if Dir.exist? './vendor'
  $LOAD_PATH.unshift('./vendor/bundle/gems/**/lib')
end

require 'loan_balances_service'
require 'loan_balances_service/aws_helpers/api_gateway'

def ping(event: {}, context: {})
  # As far as I know, Lambda does not let you send custom error messages
  # to API gateway when things go wrong. So we will assume that this works,
  # since API Gateway will send a 5xx error if it doesn't and the stacktrace
  # will appear in the logs.
  LoanBalancesService::AWSHelpers::APIGateway.ok(
    message: LoanBalancesService::HealthCheck.ping)
end

def balance(event: {}, context: {})
  # Fetches a loan balance from the providers supported within
  # lib/loan_balances_services/providers.
  if provider.nil?
    return LoanBalancesService::AWSHelpers::APIGateway.error(
      message: 'Please provide a provider to retrieve a balance from.'
    )
  end

end
