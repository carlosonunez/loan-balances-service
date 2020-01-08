#!/usr/bin/env ruby
$LOAD_PATH.unshift('./lib')
if Dir.exist? './vendor'
  $LOAD_PATH.unshift('./vendor/bundle/gems/**/lib')
end

require 'loan_balances_service'
require 'loan_balances_service/aws_helpers/api_gateway'

def ping(event: {}, context: {})
  begin
    LoanBalancesService::AWSHelpers::APIGateway.ok(
      message: LoanBalancesService::HealthCheck.ping)
  rescue
    LoanBalancesService::AWSHelpers::APIGateway.error(
      message: "App is running, but something is wrong.")
  end
end
