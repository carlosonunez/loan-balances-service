# frozen_string_literal: true

module LoanBalancesService
  module Providers
    module DATCU
      def self.balance(browser)
        browser.browse('https://online.datcu.org') do |session|
          session.visit('https://online.datcu.org')
          session.fill_in 'UsernameField', with: 'example_user'
          session.click_button 'Sign In'
          session.fill_in 'Answer', with: 'example_answer'
          session.click_button 'Next'
          session.fill_in 'PasswordField', with: 'example_password'
          session.click_button 'Next'
          require 'pry'
          binding.pry
        end
      end
    end
  end
end
