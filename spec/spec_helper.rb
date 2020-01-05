# frozen_string_literal: true

require 'yaml'
require 'httparty'
require 'loan_balances_service'

module TestMocks
  def self.generate!
    extend RSpec::Mocks::ExampleMethods
    YAML.safe_load(File.read('spec/include/mocks.yml'),
                   symbolize_names: true).each do |mock|
      allow(HTTParty)
        .to receive(:get)
        .with(mock[:url], follow_redirects: false)
        .and_return(double(HTTParty::Response,
                           code: 200,
                           body: File.read("spec/fixtures/#{mock[:page]}")))
    end
  end
end
