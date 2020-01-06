# frozen_string_literal: true

module LoanBalancesService
  module Errors
    def self.log(message)
      LoanBalancesService.logger.error message
      LoanBalancesService.logger.error "Backtrace: #{caller}"
    end
  end
end
