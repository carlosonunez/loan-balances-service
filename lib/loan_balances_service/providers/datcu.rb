# frozen_string_literal: true

require 'loan_balances_service/errors'

module LoanBalancesService
  module Providers
    module DATCU
      def self.balance(browser, **args)
        verify_parameters!(args)
        browser.browse('https://online.datcu.org') do |session|
          begin
            fill_in_username(session, args[:username])
            enter_password_and_sign_in(session, args[:password])
            answer_security_challenge(session, args[:challenge_answer])
            find_and_return_balance_usd(session, args[:account_number])
          rescue Exception => e
            LoanBalancesService::Errors.log "DATCU login failed: #{e}"
          end
        end
      end

      def self.verify_parameters!(args)
        %i[username password challenge_answer account_number].each do |arg|
          raise "Argument missing: #{arg}" unless args.key? arg
        end
      end

      def self.fill_in_username(session, username)
        session.fill_in 'UsernameField', with: username
        session.click_button 'Sign In'
        refresh_page!(session)
      end

      def self.enter_password_and_sign_in(session, _password)
        session.fill_in 'PasswordField', with: 'example_password'
        session.click_button 'Next'
        refresh_page!(session)
      end

      def self.answer_security_challenge(session, answer)
        session.fill_in 'Answer', with: answer
        session.click_button 'Next'
        refresh_page!(session)
      end

      # As far as I know, DATCU only shows their balances in USD.
      def self.find_and_return_balance_usd(session, account_number)
        stripped_acct_number = account_number.gsub(/^..../, 'XXXX')
        session.find_all('tr', text: stripped_acct_number)[0].text
               .delete("\t\n")
               .gsub(/[ ]+.*\$(.*)/, '\1')
               .delete(',')
               .to_f
      end

      def self.refresh_page!(session)
        session.refresh
      end

      private_class_method :refresh_page!
      private_class_method :find_and_return_balance_usd
      private_class_method :answer_security_challenge
      private_class_method :enter_password_and_sign_in
      private_class_method :fill_in_username
    end
  end
end
