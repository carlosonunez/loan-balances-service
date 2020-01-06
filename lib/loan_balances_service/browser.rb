# frozen_string_literal: true

require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

module LoanBalancesService
  class Browser
    DRIVER_NAME = :poltergeist
    attr_reader :session

    def initialize
      register_driver
      Capybara.default_driver = Browser::DRIVER_NAME
      Capybara.javascript_driver = Browser::DRIVER_NAME
      @session = Capybara::Session.new Browser::DRIVER_NAME
    end

    def browse(url)
      @session.visit(url)
      yield(@session)
    end

    private

    def register_driver
      Capybara.register_driver Browser::DRIVER_NAME do |app|
        Capybara::Poltergeist::Driver.new(app,
                                          phantomjs: '/opt/phantomjs/phantomjs',
                                          js_errors: false,
                                          phantomjs_options: [
                                            '--ssl-protocol=any',
                                            '--load-images=no',
                                            '--ignore-ssl-errors=yes'
                                          ])
      end
    end
  end
end
