#!/usr/bin/env ruby
$LOAD_PATH.unshift('./lib')
if Dir.exist? './vendor'
  $LOAD_PATH.unshift('./vendor/bundle/gems/**/lib')
end

require 'loan_balances_service'

def ping(event: {}, context: {})
  LoanBalancesService.ping
end
