# frozen_string_literal: true

require 'capybara'
require 'capybara/poltergeist'
require 'httparty'
require 'json'
require 'loan_balances_service'
require 'yaml'
Dir.glob('/app/spec/helpers/**/*.rb') do |file|
  require_relative file
end

module TestMocks
  RSpec.configure do |config|
    config.before(:all, :integration => true) do
      $api_gateway_url = ENV['API_GATEWAY_URL'] || Helpers::Integration::HTTP.get_endpoint
      raise "Please define API_GATEWAY_URL as an environment variable or \
  run 'docker-compose run --rm integration-setup'" \
        if $api_gateway_url.nil? or $api_gateway_url.empty?

      $test_api_key =
        Helpers::Integration::SharedSecrets.read_secret(secret_name: 'api_key') ||
          raise('Please create the "api_key" secret.')
    end
  end

  def self.generate!
    extend RSpec::Mocks::ExampleMethods
    fetch_mocks.each do |mock|
      allow(HTTParty)
        .to receive(:get)
        .with(mock[:url], follow_redirects: false)
        .and_return(double(HTTParty::Response,
                           code: 200,
                           body: File.read("spec/fixtures/#{mock[:page]}")))
    end
  end

  def self.generate_mock_session!(url)
    extend RSpec::Mocks::ExampleMethods
    mocked_page_path = find_mock(url)[:page]
    register_test_driver
    mock_session = Capybara::Session.new :poltergeist_test
    mock_session.visit("file:///app/spec/fixtures/#{mocked_page_path}")
    enable_mocked_session! mock_session
    mock_visits! url
  end

  def self.enable_mocked_session!(session)
    extend RSpec::Mocks::ExampleMethods
    allow(Capybara::Session)
      .to receive(:new)
      .with(:poltergeist)
      .and_return(session)
  end

  def self.mock_visits!(url)
    allow_any_instance_of(Capybara::Session)
      .to receive(:visit)
      .with(url)
      .and_return('status' => 'success')
  end

  def self.fetch_mocks
    YAML.safe_load(File.read('spec/include/mocks.yml'), symbolize_names: true)
  end

  def self.find_mock(url)
    fetch_mocks.find { |key| key[:url] == url }
  end

  def self.register_test_driver
    Capybara.register_driver :poltergeist_test do |app|
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
